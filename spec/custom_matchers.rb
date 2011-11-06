# encoding: utf-8

module CustomModelMatchers
  module ClassMethods
    def it_should_be_an_enumeration_for(enumeration)
      it 'has the correct enumeration values' do
        described_class.enumeration.should == enumeration
      end
    end
  end

  def self.included(receiver)
    receiver.extend ClassMethods
  end
end

module CustomControllerMatchers
end
