require 'redis'

require_relative '../geode'

module Geode
  # A store implemented using Redis.
  class RedisStore < Store
    # Connect to a store held in Redis.
    # @param name [Symbol, String] The name of the store
    # @param connection [Hash, String] Connection parameters passed to `Redis.new`.
    #                                  Defaults to empty hash
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

    def destroy
      @redis.del @name
    end
  end
end
