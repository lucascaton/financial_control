require 'factory_girl'
require 'forgery'

FactoryGirl.define do
  factory :user do
    name { Forgery(:name).full_name }
    email { Forgery(:internet).email_address }
    password('secret')
    admin('false')
    active('true')
  end

  factory :group do
    name { Forgery(:name).full_name }
  end

  factory :time_frame do
    association(:group)
    start_on Date.today.beginning_of_month
    end_on Date.today.end_of_month
  end

  factory :partnership do
    association(:user)
    association(:group)
  end
end
