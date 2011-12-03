# == Schema Information
#
# Table name: groups
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Group do
  it 'has a valid factory' do
    FactoryGirl.build(:group).should be_valid
  end

  it { should have_many(:partnerships) }
  it { should have_many(:users).through(:partnerships) }
  it { should have_many(:time_frames) }

  it { should validate_presence_of :name }

  describe '#users_humanize' do
    it 'returns a empty string' do
      group = FactoryGirl.create(:group)
      group.users_humanize.should == ''
    end

    it 'returns two users' do
      group = FactoryGirl.create :group
      user_1 = FactoryGirl.create :user, :name => 'Neo'
      user_2 = FactoryGirl.create :user, :name => 'Morpheus'
      FactoryGirl.create :partnership, :group => group, :user => user_1
      FactoryGirl.create :partnership, :group => group, :user => user_2

      group.users_humanize.should == 'Neo, Morpheus'
    end
  end
end
