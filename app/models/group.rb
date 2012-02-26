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

class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships
  has_many :time_frames, :order => :start_on

  validates_presence_of :name

  validates_uniqueness_of :name

  def users_humanize
    users.map(&:name).join(', ')
  end

  def current_time_frame
    TimeFrame.where(['group_id = ? and ? between start_on and end_on', self.id, Date.today]).first
  end

  def last_5_time_frames
    time_frames.order('start_on').limit(5)
  end

  def time_frame_errors
    if time_frames.empty?
      'Nenhum período cadastrado neste grupo.'
    elsif !current_time_frame
      'Nenhum período ativo neste grupo.'
    end
  end
end
