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
#  record_kind    :string(255)
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

  [nil, 'other'].each { |kind| it { should_not allow_value(kind).for(:kind) }}
  EntryKind.list.each { |kind| it { should allow_value(kind).for(:kind) }}

  it { should_not allow_value('other').for(:record_kind) }
  [EntryRecordKind.list << nil].flatten.each { |record_kind| it { should allow_value(record_kind).for(:record_kind) }}

  it { should belong_to :time_frame }
  # it { should belong_to :credit_card }

  it 'is invalid if bill_on is not within the time frame' do
    entry = FactoryGirl.build :entry, :bill_on => 1.month.ago.to_date
    entry.should_not be_valid
    entry.errors[:bill_on].should == ['não é compatível com período atual']
  end

  describe '#status' do
    before do
      @time_frame = FactoryGirl.create :time_frame, :start_on => 15.days.ago.to_date, :end_on => 15.days.from_now.to_date
    end

    it 'returns done' do
      entry = FactoryGirl.create(:entry, :time_frame => @time_frame, :bill_on => 1.day.ago.to_date, :done => true)
      entry.status.should == EntryStatus::DONE
    end

    it 'returns done if it have no bill_on' do
      entry = FactoryGirl.create(:entry, :time_frame => @time_frame, :bill_on => nil, :done => true)
      entry.status.should == EntryStatus::DONE
    end

    it 'returns warning' do
      entry = FactoryGirl.create(:entry, :time_frame => @time_frame, :bill_on => 5.day.from_now.to_date, :done => false)
      entry.status.should == EntryStatus::WARNING
    end

    it 'returns late' do
      entry = FactoryGirl.create(:entry, :time_frame => @time_frame, :bill_on => 1.day.ago.to_date, :done => false)
      entry.status.should == EntryStatus::LATE
    end

    it 'returns pending' do
      entry = FactoryGirl.create(:entry, :time_frame => @time_frame, :bill_on => 8.day.from_now.to_date, :done => false)
      entry.status.should == EntryStatus::PENDING
    end

    it 'returns pending if it have no bill_on' do
      entry = FactoryGirl.create(:entry, :time_frame => @time_frame, :bill_on => nil, :done => false)
      entry.status.should == EntryStatus::PENDING
    end
  end

  describe '#destroyable?' do
    it 'returns TRUE if it has NO a record_kind' do
      FactoryGirl.create(:entry, :record_kind => nil).destroyable?.should be_true
    end

    it 'returns TRUE if it is was created from a fixes entry' do
      FactoryGirl.create(:entry, :record_kind => EntryRecordKind::CREATED_FROM_A_FIXED_ENTRY).destroyable?.should be_true
    end

    it 'returns FALSE if it is a unexpected entry' do
      FactoryGirl.create(:entry, :record_kind => EntryRecordKind::UNEXPECTED).destroyable?.should be_false
    end
  end

  describe '#destroy' do
    it 'sets deleted_at if it has NO record kind' do
      entry = FactoryGirl.create :entry, :record_kind => nil
      entry.destroy
      entry.reload.deleted_at.should be_within(1).of(Time.now)
    end

    it 'sets deleted_at if it was created from a fixed entry' do
      entry = FactoryGirl.create :entry, :record_kind => EntryRecordKind::CREATED_FROM_A_FIXED_ENTRY
      entry.destroy
      entry.reload.deleted_at.should be_within(1).of(Time.now)
    end

    it 'does not set deleted_at if it cannot be destroyed' do
      entry = FactoryGirl.create :entry, :record_kind => EntryRecordKind::UNEXPECTED
      entry.destroy
      entry.reload.deleted_at.should be_nil
    end
  end

  describe '.without_record_kind' do
    DatabaseCleaner.clean
    entry_1 = FactoryGirl.create :entry
    entry_2 = FactoryGirl.create :entry, :record_kind => EntryRecordKind.list.first
    entry_3 = FactoryGirl.create :entry

    Entry.without_record_kind.should =~ [entry_1, entry_3]
  end
end
