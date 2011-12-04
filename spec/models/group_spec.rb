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

  it { should have_many(:memberships) }
  it { should have_many(:users).through(:memberships) }
  it { should have_many(:time_frames) }

  it { should validate_presence_of :name }

  it { FactoryGirl.create(:group); should validate_uniqueness_of :name }

  describe '#users_humanize' do
    it 'returns a empty string' do
      group = FactoryGirl.create(:group)
      group.users_humanize.should == ''
    end

    it 'returns two users' do
      group = FactoryGirl.create :group
      user_1 = FactoryGirl.create :user, :name => 'Neo'
      user_2 = FactoryGirl.create :user, :name => 'Morpheus'
      FactoryGirl.create :membership, :group => group, :user => user_1
      FactoryGirl.create :membership, :group => group, :user => user_2

      group.users_humanize.should == 'Neo, Morpheus'
    end
  end

  describe '#current_time_frame' do
    before :each do
      @group = FactoryGirl.create :group
    end

    it 'returns the current time frame' do
      time_frame = FactoryGirl.create :time_frame, :start_on => Date.today, :end_on => 1.month.from_now.to_date, :group => @group
      @group.current_time_frame == time_frame
    end

    it 'returns nil when the last time frame already over' do
      time_frame = FactoryGirl.create :time_frame, :start_on => 2.month.ago.to_date, :end_on => 1.month.ago.to_date, :group => @group
      @group.current_time_frame.should be_nil
    end

    it 'returns nil when there is no time frames' do
      @group.current_time_frame.should be_nil
    end
  end
end
