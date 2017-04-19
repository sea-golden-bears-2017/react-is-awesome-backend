FactoryGirl.define do
  factory :food do
    name { Faker::Food.ingredient }
    unit { Faker::Food.measurement }
  end
end
