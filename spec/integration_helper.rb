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
