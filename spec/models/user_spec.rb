# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  admin                  :boolean         default(FALSE)
#  active                 :boolean         default(TRUE)
#

require 'spec_helper'

describe User do
  it 'has a valid factory' do
    FactoryGirl.build(:user).should be_valid
  end

  it { should have_many(:memberships) }
  it { should have_many(:groups).through(:memberships) }

  it { should validate_presence_of :name }

  [true, false].each { |value| it { should allow_value(value).for(:admin) }}
  ['', nil].each { |wrong_value| it { should_not allow_value(wrong_value).for(:admin) }}

  [true, false].each { |value| it { should allow_value(value).for(:active) }}
  ['', nil].each { |wrong_value| it { should_not allow_value(wrong_value).for(:active) }}
end
