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

class TimeFrame < ActiveRecord::Base
  validates_presence_of :group_id, :start_on, :end_on
  validate :ensure_end_on_is_after_start_on

  belongs_to :group

  def self.current_for_the_group(group)
    where(['group_id = ? and ? between start_on and end_on', group.id, Date.today]).first
  end

  private
  def ensure_end_on_is_after_start_on
    return if end_on.nil? || start_on.nil?
    errors.add(:end_at, 'deve ser maior que data inicial') if end_on <= start_on
  end
end
