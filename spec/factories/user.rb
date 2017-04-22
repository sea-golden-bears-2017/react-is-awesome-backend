FactoryGirl.define do
  factory :user do
    name { Faker::Internet.user_name }
    password { Faker::Internet.password }
  end

  factory :admin, class: User do
    name { Faker::Internet.user_name }
    password { Faker::Internet.password }
    is_admin? { true }
  end
end
