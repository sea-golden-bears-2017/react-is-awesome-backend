class User < ApplicationRecord
  has_secure_password
  validates_uniqueness_of :name, case_sensitive: false
end
