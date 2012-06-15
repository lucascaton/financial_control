# encoding: utf-8

require 'spec_helper'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.configure do |config|
  config.javascript_driver = :poltergeist
  config.ignore_hidden_elements = true
  config.default_selector = :css
  config.default_wait_time = 10
  # config.asset_root = Rails.root.join('app', 'assets')
end

# http://gist.github.com/470808
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
