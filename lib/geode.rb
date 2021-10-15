module Geode
  # Subclass this to implement your own stores.
  class Store
    # Connect to a store.
    # @param name [Symbol, String] The name of the store
    # @param connection [Hash, String] Connection parameters passed to the DB client
    def initialize(name, connection = nil)
      @name = name.to_s
    end

    # "Open" the store for reading and/or writing.
    # @yield a block which receives `table` as its sole parameter
    # @yieldparam table [Hash] The table belonging to `@name`
    # @return [Object] The return value of the block
    def open
      raise NotImplementedError
    end
  end
end
