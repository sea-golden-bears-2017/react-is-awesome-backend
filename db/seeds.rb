require 'faker'
1000.times do
  Book.create(title: Faker::Book.title,
    author: Faker::Book.author,
    publisher: Faker::Book.publisher,
    genre: Faker::Book.genre)
end

author = Faker::Book.author
publisher = Faker::Book.publisher

100.times do
  Book.create(title: Faker::Book.title,
    author: author,
    publisher: publisher,
    genre: Faker::Book.genre)
end

10.times do
  Food.create(name: Faker::Food.ingredient, unit: Faker::Food.measurement)
end

10.times do
  Food.create(name: Faker::Food.spice, unit: Faker::Food.measurement)
end


100.times do
  User.create(name: Faker::Internet.unique.user_name, password: Faker::Internet.password)
end

10.times do
  user = User.create(name: Faker::Internet.unique.user_name, password: Faker::Internet.password)
  5.times do
    user.friends << User.create(name: Faker::Internet.unique.user_name, password: Faker::Internet.password)
    user.books << Book.create(title: Faker::Book.title,
      author: author,
      publisher: publisher,
      genre: Faker::Book.genre)
  end
end
