source 'https://rubygems.org'

plugin 'bundler-inject', '~> 1.1'
require File.join(Bundler::Plugin.index.load_paths("bundler-inject")[0], "bundler-inject") rescue nil

gem 'json-schema',       '~> 2.8'
gem 'manageiq-loggers',  '~> 0.1'
gem 'openapi_parser',    '~> 0.3.0'
gem 'prometheus-client', '~> 0.8.0'
gem 'puma',              '~> 3.0'
gem 'rack-cors',         '>= 0.4.1'
gem 'rails',             '~> 5.2.2'

gem 'manageiq-messaging'

gem 'manageiq-api-common', :git => 'https://github.com/ManageIQ/manageiq-api-common', :branch => 'master'
gem 'topological_inventory-core', :git => 'https://github.com/ManageIQ/topological_inventory-core', :branch => 'master'

group :development, :test do
  gem 'byebug'
  gem 'simplecov'
end

group :test do
  gem 'rspec-rails', '~>3.8'
end
