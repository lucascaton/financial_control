# encoding: utf-8

module CustomModelMatchers
  module ClassMethods
  end

  def self.included(receiver)
    receiver.extend ClassMethods
  end
end

module CustomControllerMatchers
end
