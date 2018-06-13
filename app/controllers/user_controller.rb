class UserController < ApplicationController
	before_action :authenticate_user!, except: [:digital_certificate, :token_registration, :create_user]
	### ADMIN
	def admin_dashboard
		render "users/admin_dashboard"
	end

	### USER
	def user_dashboard
		render "users/user_dashboard"
	end

	def digital_certificate
		render "users/digital_certificate_registration"
	end	
	def token_registration
		render "users/token_registration"
	end	

	def create_user
		#Validate token, #certificate
		if params[:token]
			@nominated_user = NominatedUser.find_by(registration_token: params[:token])
			if @nominated_user != nil
				redirect_to new_user_registration_path(@nominated_user)
			else
				flash[:error] = "Token does not exist"
				redirect_to :token_registration
			end
		else
			redirect_to(:root)
		end
	end
end
