# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  admin                  :boolean         default(FALSE)
#  active                 :boolean         default(TRUE)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :name, :admin, :active, :email, :password, :password_confirmation,
    :remember_me

  has_many :memberships
  has_many :groups, through: :memberships

  validates_presence_of :name

  validates_inclusion_of :admin, in: [true, false]
  validates_inclusion_of :active, in: [true, false]

  scope :active, where(:active => true)

  # Verify the active attribute in Devise authentication
  def self.find_for_database_authentication(conditions)
    email = conditions.delete(:email)
    where(conditions).where(['active = true AND email = :value', { value: email }]).first
  end
end
