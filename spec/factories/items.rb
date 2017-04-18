require 'faker'

FactoryGirl.define do
  factory :item do |f|
   f.category { Faker::Name.category }
   f.brand { Faker::Name.brand }
  end
end
