# encoding: utf-8
require 'unit_tests_helper'

describe ApplicationHelper do
  include ApplicationHelper

  describe '#select_for_users' do
    it 'returns a array for select tag' do
      user_1 = mock id: 1, name: 'Neo', email: 'neo@example.com'
      user_2 = mock id: 2, name: 'Morpheus', email: 'morpheus@example.com'

      select_for_users([user_1, user_2]).should == [['Neo (neo@example.com)', 1], ['Morpheus (morpheus@example.com)', 2]]
    end

    it 'returns a empty array' do
      select_for_users([]).should == []
    end
  end
end
