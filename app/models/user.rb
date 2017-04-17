class User < ApplicationRecord
  has_secure_password
  validates_uniqueness_of :name, case_sensitive: false
  has_many :book_users
  has_many :books, through: :book_users
end
