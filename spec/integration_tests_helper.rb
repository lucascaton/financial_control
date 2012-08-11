require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'bundler/setup'
Bundler.require 'test'
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
require File.expand_path('../support/factories', __FILE__)

Rails.logger.level = 4 # reduce the IO during tests

# Requires supporting ruby files with custom matchers and macros, etc,
Dir['./spec/integration/macros/**/*.rb'].each { |f| require f }

Capybara.configure do |config|
  config.javascript_driver = :selenium # :poltergeist
  config.ignore_hidden_elements = true
  config.default_selector = :css
  config.default_wait_time = 10
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = true

  config.include IntegrationHelpers, :type => :request

  config.before :suite do
    DatabaseCleaner.strategy = :truncation
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
