require 'faker'
100.times do
  Book.create(title: Faker::Book.title,
    author: Faker::Book.author,
    publisher: Faker::Book.publisher,
    genre: Faker::Book.genre)
end

author = Faker::Book.author
publisher = Faker::Book.publisher

10.times do
  Book.create(title: Faker::Book.title,
    author: author,
    publisher: publisher,
    genre: Faker::Book.publisher)
end
