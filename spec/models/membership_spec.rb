# == Schema Information
#
# Table name: memberships
#
#  id         :integer         not null, primary key
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Membership do
  it 'has a valid factory' do
    FactoryGirl.build(:membership).should be_valid
  end

  it { should belong_to(:user) }
  it { should belong_to(:group) }

  it { should validate_presence_of :group_id }
  it { should validate_presence_of :user_id }

  it { FactoryGirl.create :membership; should validate_uniqueness_of(:user_id).scoped_to(:group_id) }
end
