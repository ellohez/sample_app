# frozen_string_literal: true

# Class description goes here
class User < ApplicationRecord
  attr_accessor :remember_token

  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    # Creates a bcrypt (salted) hash
    BCrypt::Password.create(string, cost:)
  end

  def self.new_token
    # Creates a base64 string
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    # This method will bypass validations, necessary as we don't have user's email or password
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # Returns a session token to prevent session hijacking.
  # We reuse the remember digest for convenience.
  def session_token
    remember_digest || remember
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user - undoes user.remember by updating the remember digest with nil
  def forget
    update_attribute(:remember_digest, nil)
  end
end
