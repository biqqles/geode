# geode
**geode** provides an elegant storage mechanism for Ruby objects (including nested hashes).
It can store this data in either [Redis](https://github.com/redis/redis-rb)
or any relational database supported by [Sequel](https://github.com/jeremyevans/sequel).
Marshal is used for serialisation.

```ruby
require 'geode/redis'

store = Geode::RedisStore.new(:my_store)

store.open do |table|
  # store anything you like!
  table[:time] ||= {}
  table[:time][:now] = Time.now
end

p store.open { |table| table[:time] }
# {:now=>2021-10-15 16:34:22.664022392 +0100}
```

Inspired by [pstore](https://github.com/ruby/pstore) and [bindi](https://github.com/havenwood/bindi).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'geode'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install geode

## API listing
**More methods coming soon!**

---

### Geode::RedisStore
> `require 'geode/redis'`
>
> A store implemented using Redis.

#### `#initialize(name, connection = nil)`
Connect to a store within Redis.
##### Parameters:
- `name` (Symbol, String) The name of the store
- `connection` (Hash, String) Connection parameters passed to `Redis.new`. Defaults to empty hash

#### `#open`
"Open" the store for reading and/or writing.
##### Examples:
```ruby
store.open { |table| table[:key] = 5 }
store.open { |table| table[:key] } #=> 5
```
##### Parameters:
- a block which receives `table` as its sole parameter. Changes to this Hash will
  be persisted in the store.
   - `table` (Hash) The table belonging to `@name`
##### Returns:
(Object) The return value of the block

#### `#peek`
"Peek" inside the store, returning a copy of its table.
Changes to this copy will NOT be persisted in the store.
Use this if you simply need to fetch a value from the store.
##### Examples:
```ruby
store.peek.key?(:test) #=> false
```
##### Returns:
(Hash) A copy of the store's table

#### `#[]`
Retrieve the object at `key` from the store.
This is implemented using `#peek` and therefore
changes to the object returned by this method will NOT
be persisted in the store.
Use this if you simply need to fetch a value from the store.
##### Examples:
```ruby
store[:key] #=> 5
```
##### Parameters:
- `key` (Object) The key to look up
##### Returns:
(Object) The object at `key`

#### `#destroy`
"Destroy" the store, deleting all data.
The store can be opened again, recreating it in a blank state.

---

### Geode::SequelStore
> `require 'geode/sequel'`
>
> A store that uses a relational database supported by Sequel instead of Redis.
This is mainly useful for Heroku, where persistent Postgres is free, but
the same is not true of Redis.
Unless you have a similarly good reason to use this class, use `RedisStore` instead.

#### `#initialize(name, connection = nil)`
Connect to a store held in a relational database supported by Sequel.
A table named `geode` will be created and used to store the data.
##### Parameters:
- `name` (Symbol, String) The name of the store
- `connection` (Hash, String) Connection parameters passed to `Sequel.connect`. Defaults to `{ adapter: 'postgres' }`

#### `#open`
"Open" the store for reading and/or writing.
##### Parameters:
- a block which receives `table` as its sole parameter
    - `table` (Hash) The table belonging to `@name`
##### Returns:
(Object) The return value of the block

#### `#peek`
"Peek" inside the store, returning a copy of its table.
Changes to this copy will NOT be persisted in the store.
Use this if you simply need to fetch a value from the store.
##### Returns:
(Hash) A copy of the store's table

#### `#[]`
Retrieve the object at `key` from the store.
This is implemented using `#peek` and therefore
changes to the object returned by this method will NOT
be persisted in the store.
Use this if you simply need to fetch a value from the store.
##### Parameters:
- `key` (Object) The key to look up
##### Returns:
(Object) The object at `key`

#### `#destroy`
"Destroy" the store, deleting all data.
The store can be opened again, recreating it in a blank state.

---

## Real-world example
See [`forumlancer/storage.rb`](https://github.com/biqqles/forumlancer/blob/master/src/forumlancer/storage.rb)
and related files.
