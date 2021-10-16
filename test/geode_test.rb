# frozen_string_literal: true

require 'test_helper'
require 'redis'

class GeodeTest < Minitest::Test
  def setup
    super
    Redis.new.flushdb
    @store = Geode::RedisStore.new(:store) # TODO: run tests for SequelStore
  end

  def test_store_initialisation
    # the store name can be specified either as a symbol or a string
    @store.class.new(:my_store)
    @store.class.new('my_store')
  end

  def test_open
    @store.open do |table|
      table['key'] = 'value'
      table['nested'] = { hash: 'value' }
    end

    @store.open do |table|
      expected = { 'key' => 'value', 'nested' => { hash: 'value' } }
      assert_equal expected, table
    end
  end

  def test_readme
    require 'geode/redis'

    store = Geode::RedisStore.new(:my_store)

    store.open do |table|
      # store anything you like!
      table[:time] ||= {}
      table[:time][:now] = Time.now
    end

    p store[:time]
    # {:now=>2021-10-15 16:34:22.664022392 +0100}
  end

  def test_peek
    assert_equal({}, @store.peek)

    @store.open { |table| table[:contents] = :here }

    # peek returns the table
    assert_equal({ contents: :here }, @store.peek)
    # but changes to it are not persisted
    refute_equal(@store.peek.clear, @store.peek)
  end

  def test_reference
    assert_nil @store[:anything]

    @store.open { |table| table[:contents] = :here }

    assert_equal(:here, @store[:contents])
  end
end
