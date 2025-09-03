class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :plants, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true
  validates :password, length: { minimum: 5 }, if: -> { password.present? }
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
