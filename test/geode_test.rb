# frozen_string_literal: true

require 'test_helper'

class GeodeTest < Minitest::Test
  def test_store_initialisation
    # the store name can be specified either as a symbol or a string
    Geode::SequelStore.new(:my_store)
    Geode::SequelStore.new('my_store')
  end

  def test_storage_works
    store = Geode::SequelStore.new(:a)
    store.open do |table|
      table['key'] = 'value'
      table['nested'] = { hash: 'value' }
    end

    store.open do |table|
      expected = { 0 => 3, 'key' => 'value', 'nested' => { hash: 'value' } }
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

    p store.open { |table| table[:time] }
    # {:now=>2021-10-15 16:34:22.664022392 +0100}
  end
end
