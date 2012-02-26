# encoding: utf-8

require 'factory_girl'
require 'forgery'

FactoryGirl.define do
  factory :entry do
    association(:time_frame)
    kind { EntryKind.list.sample }
    title 'New entry'
    value { (1..400).to_a.sample.to_f }
    auto_debit false
    done false
  end

  factory :group do
    name { Forgery(:name).full_name }
  end

  factory :membership do
    association(:user)
    association(:group)
  end

  factory :time_frame do
    association(:group)
    start_on Date.today.beginning_of_month
    end_on Date.today.end_of_month
  end

  factory :user do
    name { Forgery(:name).full_name }
    email { Forgery(:internet).email_address }
    password('secret')
    admin false
    active true
  end
end
