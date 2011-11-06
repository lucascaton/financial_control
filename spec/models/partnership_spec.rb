# == Schema Information
#
# Table name: partnerships
#
#  id         :integer         not null, primary key
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Partnership do
  it 'has a valid factory' do
    FactoryGirl.build(:partnership).should be_valid
  end

  it { should belong_to(:user) }
  it { should belong_to(:group) }

  it { should validate_presence_of :group_id }
  it { should validate_presence_of :user_id }

  it { FactoryGirl.create :partnership; should validate_uniqueness_of(:user_id).scoped_to(:group_id) }
end
