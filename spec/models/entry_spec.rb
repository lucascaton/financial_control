# encoding: utf-8
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

require 'models_tests_helper'
require 'lib/extensions/currency'

describe Entry do
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

  # describe '.without_record_kind' do
  #   entry_1 = FactoryGirl.create :entry
  #   entry_2 = FactoryGirl.create :entry, :record_kind => EntryRecordKind.list.first
  #   entry_3 = FactoryGirl.create :entry

  #   Entry.without_record_kind.should =~ [entry_1, entry_3]
  # end

  describe '#update_attribute' do
    it 'returns kind humanize when update the kind attribute' do
      entry = FactoryGirl.create :entry, :kind => EntryKind::CREDIT
      entry.update_attribute(:kind, EntryKind::DEBIT).should == 'Débito (-)'
    end

    it 'returns formated value when update the value attribute' do
      entry = FactoryGirl.create :entry, :value => 130
      entry.update_attribute(:value, '145,33').should == 'R$ 145,33'
    end

    it 'returns formated bill on when update the bill on attribute' do
      entry = FactoryGirl.create :entry, :bill_on => Date.today.end_of_month
      previous_day = (Date.today.end_of_month - 1.day).strftime('%d/%m/%Y')
      entry.update_attribute(:bill_on, previous_day).should == previous_day
    end

    it 'returns auto debit humanize when update the auto debit attribute' do
      entry = FactoryGirl.create :entry, :auto_debit => true
      entry.update_attribute(:auto_debit, 'false').should == 'Não'
    end

    it 'returns status humanize when update the done attribute' do
      entry = FactoryGirl.create :entry, :done => false
      entry.update_attribute(:done, 'true').should == 'Pago'
    end

    it 'returns XXX when update the YYY attribute' do
      entry = FactoryGirl.create :entry, :title => 'Foo'
      entry.update_attribute(:title, 'Bar').should == 'Bar'
    end
  end
end
