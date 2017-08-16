# frozen_string_literal: true

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'restore_strategies/version'

Gem::Specification.new do |spec|
  spec.name          = 'restore_strategies'
  spec.version       = RestoreStrategies::VERSION
  spec.authors       = ['The For the City Network']
  spec.email         = ['info@forthecity.org']

  spec.summary       = 'A Ruby client to the Restore Strategies API'
  spec.homepage      = 'TODO: Put your gem\'s website or public repo URL here.'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'hawk-auth'
  spec.add_dependency 'json'
  spec.add_dependency 'activemodel'
  spec.add_dependency 'phoner'
  spec.add_dependency 'email_validator'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.37.2'
  spec.add_development_dependency 'faker', '~> 1.8.4'
  spec.add_development_dependency 'factory_girl', '~> 4.8.0'
  spec.add_development_dependency 'rubocop-rspec'
end
