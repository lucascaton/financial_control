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

class TimeFrame < ActiveRecord::Base
  attr_accessible :group_id, :start_on, :end_on

  validates_presence_of :group_id, :start_on, :end_on
  validate :ensure_end_on_is_after_start_on
  validate :validate_overlaps

  belongs_to :group

  has_many :entries, :dependent => :destroy

  delegate :name, to: :group, prefix: true

  def destroyable?
    # For now, every time_frame is destroyable
    true
  end

  def period
    "#{I18n.l start_on} à #{I18n.l end_on}"
  end

  private
  def ensure_end_on_is_after_start_on
    return if end_on.nil? || start_on.nil?
    errors.add(:end_at, 'deve ser maior que data inicial') if end_on <= start_on
  end

  def validate_overlaps
    return unless group

    time_frames = group.time_frames.reload
    if time_frames.any?{  |time_frame| ((time_frame.start_on..time_frame.end_on).to_a & (self.start_on..self.end_on).to_a).present? }
      errors.add :base, 'está conflitando com outro período'
    end
  end
end
