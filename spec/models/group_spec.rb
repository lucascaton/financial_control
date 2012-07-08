# encoding: utf-8
# == Schema Information
#
# Table name: groups
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'models_tests_helper'

describe Group do
  describe '#users_humanize' do
    it 'returns a empty string' do
      group = FactoryGirl.create :group
      group.users_humanize.should == ''
    end

    it 'returns just one user' do
      group = FactoryGirl.create :group
      user = FactoryGirl.create :user, :name => 'Trinity'
      FactoryGirl.create :membership, :group => group, :user => user

      group.users_humanize.should == 'Trinity'
    end

    it 'returns two users' do
      group = FactoryGirl.create :group
      user_1 = FactoryGirl.create :user, :name => 'Neo'
      user_2 = FactoryGirl.create :user, :name => 'Morpheus'
      FactoryGirl.create :membership, :group => group, :user => user_1
      FactoryGirl.create :membership, :group => group, :user => user_2

      group.users_humanize.should == 'Morpheus, Neo'
    end
  end

  describe '#current_time_frame' do
    before :each do
      @group = FactoryGirl.create :group
    end

    it 'returns the current time frame' do
      time_frame = FactoryGirl.create :time_frame, start_on: Date.today,
        end_on: 1.month.from_now.to_date, group: @group
      @group.current_time_frame == time_frame
    end

    it 'returns nil when the last time frame already over' do
      time_frame = FactoryGirl.create :time_frame, start_on: 2.month.ago.to_date,
        end_on: 1.month.ago.to_date, group: @group
      @group.current_time_frame.should be_nil
    end

    it 'returns nil when there is no time frames' do
      @group.current_time_frame.should be_nil
    end
  end

  describe '#last_5_time_frames' do
    it 'returns the last 5 time frames' do
      group = FactoryGirl.create :group

      time_frame_1 = FactoryGirl.create :time_frame, :group => group,
        :start_on => 1.months.ago.to_date.beginning_of_month, :end_on => 1.months.ago.to_date.end_of_month
      time_frame_2 = FactoryGirl.create :time_frame, :group => group,
        :start_on => 2.months.ago.to_date.beginning_of_month, :end_on => 2.months.ago.to_date.end_of_month
      time_frame_3 = FactoryGirl.create :time_frame, :group => group,
        :start_on => 3.months.ago.to_date.beginning_of_month, :end_on => 3.months.ago.to_date.end_of_month
      time_frame_4 = FactoryGirl.create :time_frame, :group => group,
        :start_on => 4.months.ago.to_date.beginning_of_month, :end_on => 4.months.ago.to_date.end_of_month
      time_frame_5 = FactoryGirl.create :time_frame, :group => group,
        :start_on => 5.months.ago.to_date.beginning_of_month, :end_on => 5.months.ago.to_date.end_of_month
      time_frame_6 = FactoryGirl.create :time_frame, :group => group,
        :start_on => 6.months.ago.to_date.beginning_of_month, :end_on => 6.months.ago.to_date.end_of_month

      group.last_5_time_frames =~ [time_frame_1, time_frame_2, time_frame_3, time_frame_4, time_frame_5]
    end
  end

  describe '#time_frame_errors' do
    it "returns 'time frame empty' message" do
      group = FactoryGirl.create :group
      group.time_frame_errors.should == 'Nenhum período cadastrado neste grupo.'
    end

    it "returns 'no current time frame' message" do
      group = FactoryGirl.create :group
      time_frame = FactoryGirl.create :time_frame, :group_id => group.id,
        :start_on => 2.month.ago.beginning_of_month.to_date, :end_on => 2.month.ago.end_of_month.to_date
      group.time_frame_errors.should == 'Nenhum período ativo neste grupo.'
    end

    it 'returns no message' do
      group = FactoryGirl.create :group
      time_frame = FactoryGirl.create :time_frame, :group_id => group.id,
        :start_on => Date.today.beginning_of_month, :end_on => Date.today.end_of_month
      group.time_frame_errors.should be_nil
    end
  end
end
