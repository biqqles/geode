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

    # "Peek" inside the store, returning a copy of its table.
    # Changes to this copy will NOT be persisted in the store.
    # Use this if you simply need to fetch a value from the store.
    # @return [Hash] A copy of the store's table
    def peek
      open(&:itself)
    end
  end
end
