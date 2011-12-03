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

  describe '#destroyable?' do
    it 'returns true' do
      # For now, every time_frame is destroyable
      time_frame = FactoryGirl.create :time_frame
      time_frame.destroyable?.should be_true
    end
  end
end
