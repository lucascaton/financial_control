# == Schema Information
#
# Table name: entries
#
#  id             :integer         not null, primary key
#  time_frame_id  :integer         not null
#  kind           :string(255)     not null
#  title          :string(255)     not null
#  description    :text
#  value          :float           default(0.0), not null
#  bill_on        :date
#  auto_debit     :boolean         default(FALSE), not null
#  credit_card_id :integer
#  done           :boolean         default(FALSE), not null
#  deleted_at     :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Entry do
  it 'has a valid factory' do
    FactoryGirl.build(:entry).should be_valid
  end

  it { should validate_presence_of :time_frame_id }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :title }
  it { should validate_presence_of :value }

  it { should_not allow_value(nil).for(:auto_debit) }
  [true, false].each { |auto_debit| it { should allow_value(auto_debit).for(:auto_debit) }}

  it { should_not allow_value(nil).for(:done) }
  [true, false].each { |done| it { should allow_value(done).for(:done) }}

  it { should belong_to :time_frame }
  # it { should belong_to :credit_card }
end
