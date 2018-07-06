class StudentApplicationFormController < ApplicationController
	before_action :authenticate_user!

	def sap_page
		@sap = current_user.student_application_form
		render "student_application_form/student_application_form"
	end

	def change_step
		if !params[:step].blank?
			@sap = current_user.student_application_form
			@sap.step = params[:step].to_i
			@sap.save!
		end
		render "student_application_form/student_application_form"
	end

	def save
		@sap = current_user.student_application_form
		@sap.update(params.require(:student_application_form).permit(
				:inst_sending_name, 
				:inst_adress,
				:school_family_dpt,
		  		:erasmus_code,
		  		:dept_coordinator,
		      	:contact_person,
		  		:inst_telephone,
		  		:inst_email,
		  		:languages,
		  		:work_experiences,
		  		:academic_year,
		  		:programme,
		  		:field_of_study,
		  		:project_work,
		  		:under_grad_courses,
		  		:reasons_abroad,
		  		:mother_tonge,
		  		:language_instruction,
		  		:current_diploma_degree,
		  		:year_attended,
		  		:specialization_area,
		  		:already_study_abroad,
		  		:where_study_abroad,
		  		:where_institution_abroad,
			))
		@sap.save!
		render "student_application_form/student_application_form"
	end

	def motivation_letter
		user = current_user
		if params[:motivation_letter]
			user.motivation_letter = params[motivation_letter]
			user.save!
		end
	end

	def curriculum_vitae
		user = current_user
		if params[:curriculum_vitae]
			user.curriculum_vitae = params[curriculum_vitae]
			user.save!
		end
	end

	def transcript_of_records
		user = current_user
		if params[:transcript_of_records]
			user.transcript_of_records = params[transcript_of_records]
			user.save!
		end
	end

	def learning_agreement
		user = current_user
		if params[:learning_agreement]
			user.learning_agreement = params[learning_agreement]
			user.save!
		end
	end

	private
	def toNumeral(number)
		numeralhash = {1=>"first", 2=>"second", 3=>"third", 4=>"forth",5=>"fifth",6=>"sixth",7=>"seventh"}
		if numeralhash.has_key?number
			numeralhash[number]
		else
			"first"
		end
	end
end
