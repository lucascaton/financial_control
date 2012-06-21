require 'unit_test'
require 'bundler/setup'
require 'active_support/i18n'
require 'active_record'
require 'enumerate_it'
require 'factory_girl'
require 'shoulda-matchers'
require File.expand_path('../support/factories', __FILE__)

# spec/support spec/integration/macros

I18n.load_path << Dir['config/locales/*.yml']
I18n.locale = 'pt-BR'
I18n.load_path.flatten!

database_yml = YAML.load_file File.expand_path('config/database.yml')
ActiveRecord::Base.establish_connection(database_yml['test'])
