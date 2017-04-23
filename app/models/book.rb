class Book < ApplicationRecord
  validates_presence_of :title, :author, :genre
  has_many :book_users, dependent: :destroy
  has_many :users, through: :book_users
end
