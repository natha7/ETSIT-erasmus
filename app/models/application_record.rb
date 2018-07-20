class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def email_uniqueness?
      if !User.find_by(:email=> email).blank? or !NominatedUser.find_by(:email=> email).blank?
      	errors.add(email, "e-mail already taken")
      end
  end

end
