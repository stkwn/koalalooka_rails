class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false }, 
                    format: { with: /\S+@\S+\.\S+/ }
  validates :password, length: { minimum: 6 }
end
