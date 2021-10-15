# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'geode/sequel'
require 'geode/redis'

require 'minitest/autorun'
