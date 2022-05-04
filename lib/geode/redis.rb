require 'redis'

require_relative '../geode'

# A store implemented using Redis.
class Geode::RedisStore
  include Geode::Store

  # Connect to a store held in Redis.
  # @param name [Symbol, String] The name of the store
  # @param connection [Hash] Connection parameters passed to `Redis.new`.
  #                          Defaults to empty hash
  def initialize(name, connection = nil)
    super
    connection ||= {}
    @redis = Redis.new(connection)
  end

  def open
    table = if @redis.exists? @name
              Marshal.load(@redis.get @name)
            else
              {}
            end

    (yield table).tap do
      @redis.set @name, Marshal.dump(table)
    end
  end

  def destroy!
    @redis.del @name
    nil
  end
end
