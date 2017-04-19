FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    password { Faker::Internet.password }
  end

  factory :admin, class: User do
    name { Faker::Name.name }
    password { Faker::Internet.password }
    is_admin? { true }
  end
end
