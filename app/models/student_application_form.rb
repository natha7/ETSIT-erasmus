class StudentApplicationForm < ApplicationRecord
	belongs_to :user
	has_many :languages
	has_many :work_experiences
	accepts_nested_attributes_for :languages, :work_experiences, allow_destroy: true

	def completed_percentage_num(uploaded_signed = false, personal_data = true)
		percentage = personal_data ? 15 : 0
		
		#Purpose of Stay
  		first = [
	  		:academic_year,
	  		:programme,
	  		:field_of_study
		]
		percentage = first.reject{|element| self[element].blank?}.length == first.length ? percentage + 14 : percentage

		second = [
	  		:inst_sending_name,
				:inst_adress,
	     	:school_family_dpt,
	  		:dept_coordinator,
				:contact_person,
	  		:inst_telephone,
	  		:inst_email
  		]

  		if self.programme and self.programme.downcase.match("erasmus")
				second.insert(-1, :erasmus_code)
		end
  		percentage = second.reject{|element| self[element].blank?}.length == second.length ? percentage + 14 : percentage

  		third = [
  			:purpose_of_stay,
  		]

  		percentage = third.reject{|element| self[element].blank?}.length == third.length ? percentage + 14 : percentage
  		
  		
  		
  		#Language Competence
  		fourth = [
	  		:mother_tongue,
	  		:language_instruction
  		]
  		percentage = fourth.reject{|element| self[element].blank?}.length == fourth.length ? percentage + 14 : percentage

  		# Work Experience
  		fifth_complete = self.work_experiences.blank? ? self.no_work_experience : true
	  	percentage = fifth_complete ? percentage + 14 : percentage  		

  		# Previous And Current Studies
  		sixth = [
	  		:current_diploma_degree,
	  		:year_attended,
	  		:specialization_area
	  	]
	  	percentage = sixth.reject{|element| self[element].blank?}.length == sixth.length ? percentage + 14 : percentage
	  	percentage = uploaded_signed ? (percentage + 1) : percentage
	  	return percentage
	end

	def completed_steps_array(uploaded_signed = false)
		
		first = [
	  		:academic_year,
	  		:programme,
	  		:field_of_study
  		]

		second = [
	  		:inst_sending_name,
				:inst_adress,
	     	:school_family_dpt,
	  		:dept_coordinator,
				:contact_person,
	  		:inst_telephone,
	  		:inst_email
  		]
		if self.programme and self.programme.downcase.match("erasmus")
			second.insert(-1, :erasmus_code)
		end

  		third = [
	  		:purpose_of_stay
		]

			fourth = [
	  		:mother_tongue,
	  		:language_instruction
  		]

  		fifth_complete = self.work_experiences.blank? ? self.no_work_experience : true


	  	sixth = [
	  		:current_diploma_degree,
	  		:year_attended,
	  		:specialization_area
	  	]
			if self.already_study_abroad
				sixth.insert(-1, :where_study_abroad, :where_institution_abroad)
			end

	  	 

	[
		first.reject{|element| self[element].blank?}.length == first.length, 
		second.reject{|element| self[element].blank?}.length == second.length,
		third.reject{|element| self[element].blank?}.length == third.length,
		fourth.reject{|element| self[element].blank?}.length == fourth.length,
		fifth_complete,
		sixth.reject{|element| self[element].blank?}.length == sixth.length
	]	
	end

	def completed_percentage(uploaded_signed = false, personal_data = true)
		completed_percentage_num(uploaded_signed, personal_data).to_s + "%"
	end

end
