# frozen_string_literal: true

# Class description goes here
class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  # Nil password only allowed for user edit actions, has_secure_password includes a separate presence validation
  # that specifically catches nil passwords
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

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

  # Forgets a user - undoes user.remember by updating the remember digest with nil
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns a session token to prevent session hijacking.
  # We reuse the remember digest for convenience.
  def session_token
    remember_digest || remember
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # update_attribute is used to bypass validations and update the activated attribute directly
  # as we don't yet have the user's email or password
  # rubocop:disable Rails/SkipsModelValidations
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  # rubocop:enable Rails/SkipsModelValidations

  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  # Converts email to all lower-case
  def downcase_email
    email&.downcase!
  end

  # Creates and assigns the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
