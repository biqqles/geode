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
##### Parameters:
- a block which receives `table` as its sole parameter
   - `table` (Hash) The table belonging to `@name`
##### Returns:
(Object) The return value of the block

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

---

## Real-world example
See [`forumlancer/storage.rb`](https://github.com/biqqles/forumlancer/blob/master/src/forumlancer/storage.rb)
and related files.
