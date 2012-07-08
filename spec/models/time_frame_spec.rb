# encoding: utf-8
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

require 'models_tests_helper'

describe TimeFrame do
  it 'is not valid if end_on is after start_on' do
    FactoryGirl.build(:time_frame, start_on: Date.today,
                      end_on: Date.yesterday).should_not be_valid
  end

  it 'is not valid if there is time frames with same period', focus: true do
    group = FactoryGirl.create :group
    FactoryGirl.create :time_frame, group: group, start_on: 15.days.ago.to_date,
      end_on: 15.days.from_now.to_date
    new_time_frame = FactoryGirl.build :time_frame, group: group,
      start_on: Date.today, end_on: 1.month.from_now.to_date
    new_time_frame.should_not be_valid
  end

  it 'is valid if there is time frames with same period, but different groups ' do
    FactoryGirl.create :time_frame, :start_on => 15.days.ago.to_date, :end_on => 15.days.from_now.to_date
    new_time_frame = FactoryGirl.build :time_frame, :start_on => Date.today, :end_on => 1.month.from_now.to_date
    new_time_frame.should be_valid
  end

  describe '#destroyable?' do
    it 'returns true' do
      # For now, every time_frame is destroyable
      time_frame = FactoryGirl.create :time_frame
      time_frame.destroyable?.should be_true
    end
  end

  describe '#period' do
    it 'return a string with period description' do
      time_frame = FactoryGirl.create :time_frame, :start_on => Date.parse('01-12-2011'), :end_on => Date.parse('31-12-2011')
      time_frame.period.should == '01/12/2011 à 31/12/2011'
    end
  end
end
