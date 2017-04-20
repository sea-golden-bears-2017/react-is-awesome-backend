class User < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many(:friends, class_name: :User, join_table: 'friends', foreign_key: 'user_a_id', association_foreign_key: 'user_b_id')
  validates_uniqueness_of :name, case_sensitive: false
  has_many :book_users
  has_many :books, through: :book_users
end
