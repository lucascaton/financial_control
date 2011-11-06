require 'factory_girl'
require 'forgery'

FactoryGirl.define do
  factory :user do
    name { Forgery(:name).full_name }
    email { Forgery(:internet).email_address }
    password('secret')
  end

  factory :group do
    name { Forgery(:name).full_name }
  end

  factory :partnership do
    association(:user)
    association(:group)
  end
end
