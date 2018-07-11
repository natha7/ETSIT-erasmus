class NominatedUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_secure_token :registration_token
  validates :email, uniqueness: true, presence: true, allow_blank: false
  validate :email_uniqueness?, :on=> :create
  after_validation :clean_errors

  private 
  def clean_errors
  	errors.delete(:email)
  end
end
