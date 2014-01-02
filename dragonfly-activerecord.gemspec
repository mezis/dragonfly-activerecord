# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dragonfly-activerecord/version'

Gem::Specification.new do |spec|
  spec.name          = 'dragonfly-activerecord'
  spec.version       = Dragonfly::ActiveRecord::VERSION
  spec.authors       = ['Julien Letessier']
  spec.email         = ['julien.letessier@gmail.com']
  spec.summary       = %q{ActiveRecord-backed data store for Dragonfly}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/mezis/dragonfly-activerecord'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'mysql2'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'

  spec.add_dependency 'activerecord', '>= 3.2.6'
end
