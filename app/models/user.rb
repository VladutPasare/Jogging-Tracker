class User < ApplicationRecord
  has_secure_password

  enum :role, {
    regular: 0,
    manager: 1,
    admin: 2
  }

  has_many :jogging_entries, dependent: :destroy

  validates :name, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
end
