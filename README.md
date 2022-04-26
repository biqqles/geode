# geode
**geode** provides an easy-to-use storage mechanism for Ruby objects (including nested hashes).
It can store this data in either [Redis](https://github.com/redis/redis-rb)
or any relational database supported by [Sequel](https://github.com/jeremyevans/sequel).

```ruby
require 'geode/redis'

store = Geode::RedisStore.new(:my_store)

store.open do |table|
  # store anything you like!
  table[:time] ||= {}
  table[:time][:now] = Time.now
end

p store[:time]
# {:now=>2021-10-15 16:34:22.664022392 +0100}
```

Marshal is used for serialisation. geode was inspired by [pstore](https://github.com/ruby/pstore)
and [bindi](https://github.com/havenwood/bindi).

## Installation

Install geode from [RubyGems](https://rubygems.org/gems/geode):

```console
$ gem install geode
```

Or add this line to your application's Gemfile:

```ruby
gem 'geode'
```

And then execute:

```console
$ bundle install
```

# Usage
## `Store`
A [`Store`](lib/geode.rb) is simply an abstraction (over some underlying database) of a key-value
store, where the values can be any Ruby object. Hashes as values enable hierarchical data
organisation.

geode provides two types of `Store`: [`RedisStore`](#redisstore) and [`SequelStore`](#sequelstore).
As the names suggest, these differ in terms of which database adapters they use, but otherwise,
all their methods behave identically.

**A store, once initialised, has three basic operations; `#open`, `#peek` and `#destroy`:**

---
### `#open`
"Open" the store for reading and/or writing.

```ruby
store.open { |table| table[:key] = 5 }
store.open { |table| table[:key] } #=> 5
```
- ##### Parameters:
	- a block which receives `table` as its sole parameter. Changes to this Hash will
  be persisted in the store.
	- `table` (Hash) The table belonging to `@name`
- ##### Returns:
    - (Object) The return value of the block
---
### `#peek`
"Peek" inside the store, returning a copy of its table.
Changes to this copy will NOT be persisted in the store.
Use this if you simply need to fetch a value from the store.

```ruby
store.peek.key?(:test) #=> false
```

- ##### Returns:
    - (Hash) A copy of the store's table
---
### `#[]`
Retrieve the object at `key` from the store.
This is sugar for `#peek[]` and therefore
changes to the object returned by this method will NOT
be persisted in the store.
Use this if you simply need to fetch a value from the store.

```ruby
store[:key] #=> 5
```
- ##### Parameters:
    - `key` (Object) The key to look up
- ##### Returns:
    - (Object) The object at `key`
---
### `#destroy`
"Destroy" the store, deleting all data.
The store can be opened again, recreating it in a blank state.

```ruby
store.destroy
```
---

**To implement your own variants of `Store`:**
- include `Geode::Store` in your class
- implement the `#initialize`, `#open` and `#destroy` methods.

## `RedisStore`
[*`require 'geode/redis'`*](lib/geode/redis.rb)

A store implemented using Redis.

### `#initialize(name, connection = nil)`
Connect to a store within Redis.
- ##### Parameters:
    - `name` (Symbol, String) The name of the store
    - `connection` (Hash, String) Connection parameters passed to `Redis.new`.
       Defaults to empty hash

## `SequelStore`
[*`require 'geode/sequel'`*](lib/geode/sequel.rb)

A store that uses a relational database supported by Sequel instead of Redis.
This is mainly useful for Heroku, where
[persistent Postgres is free](https://elements.heroku.com/addons/heroku-postgresql), but
the same is [not true of Redis](https://elements.heroku.com/addons/heroku-redis).
Unless you have a similarly good reason to use this class, use `RedisStore` instead.

The `pg` gem will be installed by default. If you need to work with a database other than Postgres,
you should install that database's adapter yourself. Sequel will determine the adapter it uses
based on the `connection` hash.

### `#initialize(name, connection = nil)`
Connect to a store held in a relational database supported by Sequel.
A table named `geode` will be created and used to store the data.
- ##### Parameters:
    - `name` (Symbol, String) The name of the store
    - `connection` (Hash, String) Connection parameters passed to `Sequel.connect`.
       Defaults to `{ adapter: 'postgres' }`
