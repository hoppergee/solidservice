# frozen_string_literal: true

source "https://rubygems.org"

if rails_version = ENV['RAILS_VERSION']
  gem 'rails', rails_version
end

# Specify your gem's dependencies in solidservice.gemspec
gemspec

gem "rake", "~> 13.0"

gem "minitest", "~> 5.0"

group :development, :test do
  gem "debug"
  gem 'matrixeval-ruby'
end