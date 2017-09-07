# frozen_string_literal: true

require 'faker'

church_names = [
  '1st Baptist', 'Community Bible', 'Bible Church', 'United Methodist',
  'Cornerstone', 'Covenant', 'Grace', 'Cross', 'Life', 'Mount Zion',
  'Promise', 'Providence', 'Redeemer', 'St David', 'St John', 'St Paul',
  'St Peter'
]

FactoryGirl.define do
  factory :user, class: RestoreStrategies::User do
    given_name { Faker::Name.first_name }
    family_name { Faker::Name.last_name }
    church { church_names[Random.rand(church_names.length - 1)] }
    church_size { Random.rand(8000) }
    website { "http://#{Faker::Internet.domain_name}" }
    email { Faker::Internet.email }
    telephone { Faker::PhoneNumber.phone_number }
    franchise_city { Faker::Address.city }
    street_address { Faker::Address.street_address }
    address_locality { Faker::Address.city }
    address_region { Faker::Address.state }
    postal_code {  Faker::Address.zip }
  end
end
