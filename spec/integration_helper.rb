require 'spec_helper'

Capybara.default_selector = :css
Capybara.ignore_hidden_elements = true
Capybara.default_wait_time = 10

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
