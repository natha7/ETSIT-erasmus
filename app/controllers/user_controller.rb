class UserController < ApplicationController
	before_action :authenticate_user!, except: [:digital_certificate, :token_registration, :create_user, :register_with_email_and_password, :register_with_eidas]
	### ADMIN
	def admin_dashboard
		render "users/admin_dashboard"
	end

	### USER
	def user_dashboard
		render "users/user_dashboard"
	end

	def register_with_email_and_password
		@nominated_user = NominatedUser.find_by :registration_token => params[:token_registration]
		unless @nominated_user.blank?
			render "users/registration"
		end
	end

	def register_with_eidas
		#do things with eidas then render
		render "users/registration"
	end

	def file_upload
		unless params[:user].blank?
			keys = params[:user].keys
			current_user.update_attribute(keys[0], params[:user][keys[0]])
			current_user.save!
		else 
			flash[:error] = "File not valid"
		end
		redirect_to user_dashboard_path
	end

	def file_delete
		case params[:attachment]
		when "motivation_letter"
			current_user.motivation_letter = nil
			current_user.save!
		when "curriculum_vitae"
			current_user.curriculum_vitae = nil
			current_user.save!
		when "transcript_of_records"			
			current_user.transcript_of_records = nil
			current_user.save!
		when "learning_agreement"
			current_user.learning_agreement = nil
			current_user.save!
		else
			flash[:error] = "There was an error"
		end

		redirect_to user_dashboard_path
	end

end
