class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :username, with: ->(username) { username.strip.downcase }
end
