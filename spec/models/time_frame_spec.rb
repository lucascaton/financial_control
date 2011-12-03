# == Schema Information
#
# Table name: time_frames
#
#  id         :integer         not null, primary key
#  group_id   :integer
#  start_on   :date
#  end_on     :date
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe TimeFrame do
  it 'has a valid factory' do
    FactoryGirl.build(:time_frame).should be_valid
  end

  it { should validate_presence_of :group_id }
  it { should validate_presence_of :start_on }
  it { should validate_presence_of :end_on }

  it { should belong_to :group }

  it 'is not valid if end_on is after start_on' do
    FactoryGirl.build(:time_frame, :start_on => Date.today, :end_on => Date.yesterday).should_not be_valid
  end

  describe '.current' do
    it 'returns the current time frame' do
      time_frame = FactoryGirl.create :time_frame, :start_on => Date.today, :end_on => 1.month.from_now.to_date
      TimeFrame.current.should == time_frame
    end

    it 'returns nil when the last time frame already over' do
      time_frame = FactoryGirl.create :time_frame, :start_on => 2.month.ago.to_date, :end_on => 1.month.ago.to_date
      TimeFrame.current.should be_nil
    end

    it 'returns nil when there is no time frames' do
      TimeFrame.current.should be_nil
    end
  end
end
