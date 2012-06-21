require 'active_support/dependencies'

%w(app/enumerations app/models app/helpers).each do |path|
  unless ActiveSupport::Dependencies.autoload_paths.include?(path)
    ActiveSupport::Dependencies.autoload_paths.push(path)
  end
end
