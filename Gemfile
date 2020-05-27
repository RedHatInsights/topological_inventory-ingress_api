source 'https://rubygems.org'

plugin 'bundler-inject', '~> 1.1'
require File.join(Bundler::Plugin.index.load_paths("bundler-inject")[0], "bundler-inject") rescue nil

gem "cloudwatchlogger",    "~> 0.2"
gem 'insights-api-common', '~> 4.0'
gem 'json-schema',         '~> 2.8'
gem 'manageiq-loggers',    "~> 0.4.0", ">= 0.4.2"
gem 'prometheus-client',   '~> 0.8.0'
gem 'puma',                '>= 4.3.3', '~> 4.3'
gem 'rack-cors',           '>= 1.0.4', '~> 1.0'
gem 'rails',               '~> 5.2.2'

gem 'manageiq-messaging'

gem 'topological_inventory-core', '~> 1.1.1'

group :development, :test do
  gem 'byebug'
  gem 'rubocop',             "~>0.69.0", :require => false
  gem 'rubocop-performance', "~>1.3",    :require => false
  gem "simplecov",           "~>0.17.1"
end

group :test do
  gem 'rspec-rails', '~>3.8'
end
