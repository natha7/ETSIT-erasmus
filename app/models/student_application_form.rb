class StudentApplicationForm < ApplicationRecord
	belongs_to :user
	has_many :languages
	has_many :work_experiences
	accepts_nested_attributes_for :languages, :work_experiences
end
