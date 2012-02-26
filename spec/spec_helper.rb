# encoding: utf-8

module FasterTests
  def scrub_instance_variables
    reserved_ivars = %w(@loaded_fixtures @test_passed @fixture_cache @method_name @_assertion_wrapped @_result)
    (instance_variables - reserved_ivars).each do |ivar|
      instance_variable_set(ivar, nil)
    end
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/mocks'
require 'capybara/rspec'
require 'capybara/rails'
# require 'fakeweb'
require 'spec/custom_matchers'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("spec/integration/macros/**/*.rb")].each {|f| require f}

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.mock_with :rspec

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.include CustomModelMatchers, :type => :model
  config.include FasterTests
  config.before(:all) { scrub_instance_variables }

  config.include IntegrationHelpers, :type => :request if defined? IntegrationHelpers

  config.before :each do
    Capybara.reset_sessions!
    DatabaseCleaner.clean
  end
end
