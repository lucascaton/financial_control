# encoding: utf-8
# == Schema Information
#
# Table name: memberships
#
#  id         :integer         not null, primary key
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Membership < ActiveRecord::Base
  attr_accessible :group_id, :user_id

  belongs_to :user
  belongs_to :group

  validates_presence_of :group_id, :user_id
  validates_uniqueness_of :user_id, :scope => [:group_id]
end
