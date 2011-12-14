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

class Entry < ActiveRecord::Base
  validates_presence_of :time_frame_id, :kind, :title, :value
  validates_inclusion_of :auto_debit, :in => [true, false]
  validates_inclusion_of :done, :in => [true, false]
  validates_inclusion_of :kind, :in => EntryKind.list

  belongs_to :time_frame
  # belongs_to :credit_card

  has_enumeration_for :kind, :with => EntryKind, :create_helpers => true

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
end
