class User < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many(:friends, class_name: :User, join_table: 'friends', foreign_key: 'user_id', association_foreign_key: 'friend_id')
  validates_presence_of :name
  has_many :book_users
  has_many :books, through: :book_users

  def has_friend?(user_id)
    self.friends.exists?(user_id)
  end

  def is_friend_of?(user_id)
    user = User.find_by(id: user_id)
    user && user.has_friend?(self.id)
  end
end
