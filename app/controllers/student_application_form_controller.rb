class StudentApplicationFormController < ApplicationController
	before_action :authenticate_user!

	def studentform
		render "student_application_form/#{current_user.step}_step"
	end

	def save_step
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
			numberalhash[number]
		else
			nil
		end
	end
end
