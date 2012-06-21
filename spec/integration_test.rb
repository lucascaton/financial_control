ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'machinist/active_record'
require 'machinist/caching/active_record'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
spec_support = Rails.root.join('spec/support/**/*.rb')
blueprints   = Rails.root.join('spec/blueprints/**/*.rb')
Dir[spec_support, blueprints].each { |f| require(f) }

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Helpers
  config.include GatewayMatchers

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before do
    DatabaseCleaner.start
    Machinist::Caching::Shop.instance.reset!
  end

  config.after do
    DatabaseCleaner.clean
  end
end
