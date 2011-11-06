require 'factory_girl'
require 'forgery'

FactoryGirl.define do
  factory :user do
    name { Forgery(:name).full_name }
    # association(:group)
    email { Forgery(:internet).email_address }
    password('secret')
  end
end
