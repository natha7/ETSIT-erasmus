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

	def review_dashboard
		render "users/review_dashboard"
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
		puts params[:user]
		unless params[:user].blank?
			keys = params[:user].keys
			current_user.assign_attributes({keys[0] => params[:user][keys[0]]})
			unless current_user.save
				flash[:error] = current_user.errors.full_messages.to_sentence
			end
		else 
			flash[:error] = "File not valid"
		end
		redirect_to user_dashboard_path
	end
	def file_upload_ajax
		puts params[:user]
		url = ""
		unless params[:user].blank?
			keys = params[:user].keys
			current_user.assign_attributes({keys[0] => params[:user][keys[0]]})
			unless current_user.save
				head :forbidden
				return
			end
			url = current_user.send(keys[0])  
		else 
			head :forbidden
			return
		end

		render :json => {:url => url }


	end
	def file_delete
		case params[:attachment]
		when "motivation_letter"
			current_user.motivation_letter = nil
			current_user.save!
		when "curriculum_vitae"
			current_user.curriculum_vitae = nil
			current_user.save!
		when "valid_insurance_policy"
			current_user.valid_insurance_policy = nil
			current_user.save!
		when "ni_passport"
			current_user.ni_passport = nil
			current_user.save!
		when "transcript_of_records"			
			current_user.transcript_of_records = nil
			current_user.save!
		when "learning_agreement"
			current_user.learning_agreement = nil
			current_user.save!
		when "photo"
			current_user.photo = nil
			current_user.save!
		when "recommendation_letter_1"
			current_user.recommendation_letter_1 = nil
			current_user.save!
		when "recommendation_letter_2"			
			current_user.recommendation_letter_2 = nil
			current_user.save!
		when "official_gpa"
			current_user.official_gpa = nil
			current_user.save!
		when "english_test_score"
			current_user.english_test_score = nil
			current_user.save!
		else
			flash[:error] = "There was an error"
		end

		redirect_to user_dashboard_path
	end

end
