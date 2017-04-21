require 'bundler/setup'

require 'simplecov'
SimpleCov.start 'rails' do
  add_filter 'app/docs'
  add_filter 'apress/documentation/version'
  minimum_coverage 95
end

require 'apress/documentation'

require 'pry'
require 'sqlite3'

require 'combustion'
Combustion.initialize! :action_controller do
  config.cache_store = :memory_store
  config.eager_load = true
end

require 'rspec/rails'
