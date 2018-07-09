class StudentApplicationForm < ApplicationRecord
	belongs_to :user
	has_many :languages
	has_many :work_experiences
	accepts_nested_attributes_for :languages, :work_experiences

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
  		percentage = first.reject{|element| self[element].blank?}.length == first.length ? percentage + 20 : percentage

  		second = [
	  		:academic_year,
	  		:programme,
	  		:field_of_study
  		]
  		percentage = second.reject{|element| self[element].blank?}.length == second.length ? percentage + 20 : percentage
  		#Purpose of Stay
  		third = [
	  		:project_work,
	  		:under_grad_courses,
	  		:graduate_courses
		]
		percentage = third.reject{|element| self[element].blank?}.length == third.length ? percentage + 20 : percentage
  		#Language Competence
  		forth = [
	  		:mother_tongue,
	  		:language_instruction
  		]
  		percentage = forth.reject{|element| self[element].blank?}.length == forth.length ? percentage + 20 : percentage
  		#Previous And Current Studies
  		fifth = [
	  		:current_diploma_degree,
	  		:year_attended,
	  		:specialization_area
	  	]
	  	percentage = fifth.reject{|element| self[element].blank?}.length == fifth.length ? percentage + 20 : percentage
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
	  		:academic_year,
	  		:programme,
	  		:field_of_study
  		]

  		third = [
	  		:project_work,
	  		:under_grad_courses,
	  		:graduate_courses
		]

		forth = [
	  		:mother_tongue,
	  		:language_instruction
  		]

  		fifth = [
	  		:current_diploma_degree,
	  		:year_attended,
	  		:specialization_area
	  	]

		[
			first.reject{|element| self[element].blank?}.length == first.length, 
			second.reject{|element| self[element].blank?}.length == second.length,
			third.reject{|element| self[element].blank?}.length == third.length,
			forth.reject{|element| self[element].blank?}.length == forth.length,
			fifth.reject{|element| self[element].blank?}.length == fifth.length
		]	
	end

	def completed_percentage
		completed_percentage_num.to_s + "%"
	end

end
