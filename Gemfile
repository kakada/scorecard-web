# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.0.3", ">= 6.0.3.4"
# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"
# Use Puma as the app server
gem "puma", "~> 4.1"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem "bootstrap", "~> 4.5.2"
gem "haml", "~> 5.1.2"
gem "haml-rails", "~> 2.0"
gem "jquery-rails",   "~> 4.4.0"
gem "coffee-rails",   "~> 5.0.0"

gem "devise", "~> 4.7.2"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

gem "omniauth-google-oauth2"
gem "sentry-raven", "~> 3.0.4"
gem "pagy", "~> 3.5"
gem "pumi", require: "pumi/rails"
gem "carrierwave", "~> 2.1"
gem "pundit", "~> 2.1.0"
gem "simple_form", "~> 5.0.3"
gem "awesome_nested_set", "~> 3.2.1"
gem "roo", "~> 2.8.3"
gem "active_model_serializers", "~> 0.10.10"

gem "bootstrap4-datetime-picker-rails", "~> 0.3.1"

gem "strip_attributes", "~> 1.11.0"
gem "ndjson", "~> 1.0.0"
gem "fog-aws", "~> 3.8.0"
gem "date_validator", "~> 0.10.0"

gem 'whenever', "~> 1.0.0", require: false
gem "database_cleaner-active_record", "~> 1.8.0"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails", "~> 6.1.0"
  gem "ffaker", "~> 2.17.0"
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop-performance", "~> 1.7.1"
  gem "rubocop-rails", "~> 2.7.1"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen", "~> 3.2"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"

  gem "annotate", "~> 3.1.1"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "shoulda-matchers", "~> 4.0"
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
