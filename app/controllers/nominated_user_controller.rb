class NominatedUserController < ApplicationController
	before_action :authenticate_user!, except: [:register]
	before_action :validate_not_user?, only: [:register]
	before_action :validate_admin?, only: [:create_nominee, :resend_email, :delete_nominee]


	def create_nominee
			nominee = NominatedUser.new
			nominee.email = params[:email]
			unless nominee.save
				flash[:error] = "Email already registered"
				redirect_to admin_dashboard_path
			else
				url = request.base_url
				NomineeMailer.user_creation_email(nominee, url).deliver_now
				redirect_to admin_dashboard_path
			end
	end

	def resend_email
			nominee = NominatedUser.find_by :id => params[:id]
			nominee.regenerate_registration_token
			url = request.base_url
			NomineeMailer.user_creation_email(nominee, url).deliver_now
		end

	end

	def delete_nominee
			nominee = NominatedUser.find_by :id => params[:id]
			nominee.destroy!

			redirect_to admin_dashboard_path
	end

	def register
		@nominee = NominatedUser.find_by(:registration_token => params[:token_registration])
		if @nominee.blank?
			render status: :forbidden, text: 'You do not have access to this page.'
		else  
			render "users/register_choice"
		end
	end
end