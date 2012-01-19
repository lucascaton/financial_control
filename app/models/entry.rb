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

class Entry < ActiveRecord::Base
  validates_presence_of :time_frame_id, :kind, :title, :value
  validates_inclusion_of :auto_debit, :in => [true, false]
  validates_inclusion_of :done, :in => [true, false]
  validates_inclusion_of :record_kind, :in => EntryRecordKind.list, :allow_nil => true

  validate :validate_time_frame_period

  belongs_to :time_frame
  # belongs_to :credit_card

  has_enumeration_for :kind, :with => EntryKind, :create_helpers => true, :required => true
  has_enumeration_for :record_kind, :with => EntryRecordKind, :create_helpers => true

  scope :active, where(:deleted_at => nil)
  scope :without_record_kind, where(:record_kind => nil)

  def status
    if done?
      EntryStatus::DONE
    elsif bill_on && bill_on <= Date.today
      EntryStatus::LATE
    elsif bill_on && bill_on <= 7.days.from_now.to_date
      EntryStatus::WARNING
    else
      EntryStatus::PENDING
    end
  end

  def destroy
    update_attribute :deleted_at, Time.now
  end

  private
  def validate_time_frame_period
    return if bill_on.nil?
    unless bill_on.between? time_frame.start_on, time_frame.end_on
      errors.add :bill_on, :bill_on_invalid_with_this_time_frame
    end
  end
end
