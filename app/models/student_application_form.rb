class StudentApplicationForm < ApplicationRecord
	belongs_to :user, dependent: :destroy
end