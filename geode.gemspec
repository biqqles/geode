require_relative 'lib/geode/version'

Gem::Specification.new do |spec|
  spec.name          = 'geode'
  spec.version       = Geode::VERSION
  spec.author        = 'biqqles'
  spec.email         = 'biqqles@protonmail.com'

  spec.license       = 'MPL-2.0'
  spec.summary       = 'Elegantly store Ruby objects in Redis or Sequel'
  spec.homepage      = 'https://github.com/biqqles/geode'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/releases"

  spec.files = %w[lib/geode.rb lib/geode/redis.rb lib/geode/sequel.rb]
  spec.require_paths = ['lib']

  spec.add_dependency 'pg', '~> 1.0'
  spec.add_dependency 'redis', '~> 4.0'
  spec.add_dependency 'sequel', '~> 5.0'
end
