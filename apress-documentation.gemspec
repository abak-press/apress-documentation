# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apress/documentation/version'

Gem::Specification.new do |spec|
  spec.name          = 'apress-documentation'
  spec.version       = Apress::Documentation::VERSION
  spec.authors       = ['Korobicyn Denis']
  spec.email         = ['deniskorobitcin@gmail.com']
  spec.summary       = 'apress-documentation'
  spec.description   = 'apress-documentation'
  spec.homepage      = 'https://github.com/abak-press/apress-documanetation'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.metadata['allowed_push_host'] = 'https://gems.railsc.ru'

  spec.add_runtime_dependency 'rails', '>= 3.2'
  spec.add_runtime_dependency 'haml-rails', '>= 0.4'
  spec.add_runtime_dependency 'swagger-blocks', '>= 1.3'

  spec.add_development_dependency "bundler", ">= 1.14"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec", ">= 3.0"
  spec.add_development_dependency 'rspec-rails', '>= 3.2'
  spec.add_development_dependency 'combustion', '>= 0.5.4'
  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'simplecov', '>= 0.9'
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'pry-byebug'
end
