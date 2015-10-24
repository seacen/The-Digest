class User < ActiveRecord::Base
  # Validations
  has_secure_password
  validates_presence_of :email, :first_name, :last_name, :username
  validates :email, format: { with: /(.+)@(.+).[a-z]{2,4}/, message: "%{value} is not a valid email" }
  validates :username, length: { minimum: 3 }
  validate :username_not_changed
  validates :email, uniqueness: true

  # Users can have interests
  acts_as_taggable_on :interests

  def full_name
    first_name + ' ' + last_name
  end

  def username_not_changed
    return unless username_changed? && self.persisted?
    errors.add(:username, 'change is not allowed')
  end
end
