FactoryGirl.define do
  factory :user do
    name { Faker::Name.name}
    password_digest { Faker::Internet.password}
  end
end
