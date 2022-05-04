require 'sequel'

require_relative '../geode'

# A store that uses a relational database supported by Sequel instead of Redis.
# This is mainly useful for Heroku, where persistent Postgres is free, but
# the same is not true of Redis.
# Unless you have a similarly good reason to use this class, use `RedisStore` instead.
class Geode::SequelStore
  include Geode::Store

  # Connect to a store held in a relational database supported by Sequel.
  # A table named `geode` will be created and used to store the data.
  # @param name [Symbol, String] The name of the store
  # @param connection [Hash, String] Connection parameters passed to `Sequel.connect`.
  #                                  Defaults to `{ adapter: 'postgres' }`
  def initialize(name, connection = nil)
    super

    connection ||= { adapter: 'postgres' }
    db = Sequel.connect(connection)
    db.create_table? :geode do
      String :name, primary_key: true
      File :value
    end

    @db = db[:geode]
  end

  def open
    store = @db.where(name: @name)
    table = if store.empty?
              store.insert(name: @name, value: '')
              {}
            else
              Marshal.load(store.first[:value])
            end

    (yield table).tap do
      store.update(value: Sequel.blob(Marshal.dump(table)))
    end
  end

  def destroy!
    @db.where(name: @name).delete
    nil
  end
end
