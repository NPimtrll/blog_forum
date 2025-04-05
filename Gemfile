source "https://rubygems.org"

# Core gems
gem "rails", "~> 8.0.1"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"
gem "bootsnap", require: false

# Network gems
gem "net-protocol", "~> 0.2.2"
gem "net-pop", "~> 0.1.2"

# Frontend gems
gem "font-awesome-sass", "~> 6.0"
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"

# Authentication & Authorization
gem "devise", "~> 4.9"

# Pagination
gem "kaminari"

# Rich text editor
gem "tinymce-rails", "~> 6.8"

# Background jobs and caching
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Deployment
gem "kamal", require: false
gem "thruster", require: false

# Windows compatibility
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Environment variables
gem "dotenv-rails", groups: [ :development, :test ]

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw jruby ], require: "debug/prelude"
  gem "faker"
  gem "brakeman", "~> 7.0.2", require: false
  gem "rspec-rails"
  gem "rubocop-rails-omakase", require: false
  gem "shoulda-matchers"
  gem "rails-controller-testing"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "factory_bot_rails"
  gem "simplecov", require: false, git: "https://github.com/simplecov-ruby/simplecov"
end
