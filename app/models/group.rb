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
  has_many :partnerships
  has_many :users, :through => :partnerships
  has_many :time_frames, :order => :start_on

  validates_presence_of :name

  def users_humanize
    users.map(&:name).join(', ')
  end

  def current_time_frame
    TimeFrame.where(['group_id = ? and ? between start_on and end_on', self.id, Date.today]).first
  end
end
