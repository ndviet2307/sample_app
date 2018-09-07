class User < ApplicationRecord
  before_save{email.downcase}
  validates :name, presence: true, length: {maximum: Settings.user.name.length}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
    length: {maximum: Settings.user.email.length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: Settings.user.case_sensitive}
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.user.password}
end
