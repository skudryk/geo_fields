source "https://rubygems.org"
ruby '3.2.1'

gem "rails", "~> 8.0.3"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

gem "pg", "~> 1.1"
gem "activerecord-postgis-adapter"

gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

gem "turbo-rails"
gem "stimulus-rails"


gem "rgeo-geojson"

gem "responders"

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false

gem "kamal", require: false

# HTTP asset caching/compression and X-Sendfile acceleration for Puma
gem "thruster", require: false

group :development, :test do
  gem "brakeman", require: false

  # Omakase Ruby styling
  gem "rubocop-rails-omakase", require: false

  # Testing
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "shoulda-matchers"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end
