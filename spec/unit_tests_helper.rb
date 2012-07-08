require 'pry'
require 'active_support/dependencies'

rails_root = File.expand_path(File.dirname(__FILE__) + '/..')
$LOAD_PATH.unshift(rails_root) unless $LOAD_PATH.include?(rails_root)

%w(app/enumerations app/models app/helpers).each do |path|
  unless ActiveSupport::Dependencies.autoload_paths.include?(path)
    ActiveSupport::Dependencies.autoload_paths.push(path)
  end
end
