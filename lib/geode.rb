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
    # @yieldparam table [Hash] The store's table. Changes to this Hash will
    # be persisted in the store
    # When in doubt, use this method.
    # @example
    #   "store.open { |table| table[:key] = 5 }"
    # @example
    #   "store.open { |table| table[:key] } #=> 5"
    # @return [Object] The return value of the block
    def open
      raise 'subclasses must implement #open'
    end

    # "Peek" inside the store, returning a copy of its table.
    # Changes to this copy will NOT be persisted in the store.
    # Use this if you simply want to view the store's table.
    # @example
    #   "store.peek.key?(:test) #=> false"
    # @return [Hash] A copy of the store's table
    def peek
      open(&:itself)
    end

    # Retrieve the object at `key` from the store.
    # This is implemented using `#peek` and therefore
    # changes to the object returned by this method will NOT
    # be persisted in the store.
    # Use this if you simply need to fetch a value from the store.
    # @example
    #   "store[:key] #=> 5"
    # @param key [Object] The key to look up
    # @return [Object] The object at `key`
    def [](key)
      peek[key]
    end

    # "Destroy" the store, deleting all data.
    # The store can be opened again, recreating it in a blank state.
    def destroy
      raise 'subclasses must implement #destroy'
    end
  end
end
