FactoryGirl.define do
  factory :book do
    title { Faker::Book.title }
    author { Faker::Book.author }
    genre { Faker::Book.genre }
    publisher { Faker::Book.publisher }
  end
end
