class StudentApplicationForm < ApplicationRecord
	belongs_to :user
	has_many :languages
	has_many :work_experiences
	accepts_nested_attributes_for :languages, :work_experiences, allow_destroy: true

	def completed_percentage_num
		percentage = 0
		
		first = [
	  		:inst_sending_name,
	      	:inst_adress,
	     	:school_family_dpt,
	  		:erasmus_code,
	  		:dept_coordinator,
	      	:contact_person,
	  		:inst_telephone,
	  		:inst_email
  		]
  		percentage = first.reject{|element| self[element].blank?}.length == first.length ? percentage + 17 : percentage

  		second = [
  			:project_work,
	  		:under_grad_courses,
	  		:graduate_courses
	  		
  		]
  		percentage = second.reject{|element| self[element].blank?}.length == second.length ? percentage + 17 : percentage
  		#Purpose of Stay
  		third = [
	  		:academic_year,
	  		:programme,
	  		:field_of_study
		]
		percentage = third.reject{|element| self[element].blank?}.length == third.length ? percentage + 17 : percentage
  		#Language Competence
  		fourth = [
	  		:mother_tongue,
	  		:language_instruction
  		]
  		percentage = fourth.reject{|element| self[element].blank?}.length == fourth.length ? percentage + 16 : percentage
  		# Work Experience
  		fifth_complete = self[:work_experiences].blank? ? self[:no_work_experience] : false

	  	percentage = fifth_complete ? percentage + 16 : percentage  		

  		#Previous And Current Studies
  		sixth = [
	  		:current_diploma_degree,
	  		:year_attended,
	  		:specialization_area
	  	]
	  	percentage = sixth.reject{|element| self[element].blank?}.length == sixth.length ? percentage + 17 : percentage
	end

	def completed_steps_array
		first = [
	  		:inst_sending_name,
	      	:inst_adress,
	     	:school_family_dpt,
	  		:erasmus_code,
	  		:dept_coordinator,
	      	:contact_person,
	  		:inst_telephone,
	  		:inst_email
  		]

  		second = [
	  		:project_work,
	  		:under_grad_courses,
	  		:graduate_courses
		]

  		third = [
	  		:academic_year,
	  		:programme,
	  		:field_of_study
  		]

		fourth = [
	  		:mother_tongue,
	  		:language_instruction
  		]

  		fifth_complete = self[:work_experiences].blank? ? self[:no_work_experience] : false

	  	sixth = [
	  		:current_diploma_degree,
	  		:year_attended,
	  		:specialization_area
	  	]

	[
		first.reject{|element| self[element].blank?}.length == first.length, 
		second.reject{|element| self[element].blank?}.length == second.length,
		third.reject{|element| self[element].blank?}.length == third.length,
		fourth.reject{|element| self[element].blank?}.length == fourth.length,
		fifth_complete,
		sixth.reject{|element| self[element].blank?}.length == sixth.length
	]	
	end

	def completed_percentage
		completed_percentage_num.to_s + "%"
	end

end
