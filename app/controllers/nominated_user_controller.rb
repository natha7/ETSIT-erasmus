class NominatedUserController < ApplicationController
	def create_nominee
		if current_user.admin?
			nominee = NominatedUser.new
			nominee.email = params[:email]
			nominee.save!

			redirect_to admin_dashboard_path
		else
			redirect_to root
		end
	end

	def resend_email
		
	end

	def delete_nominee
		if current_user.admin?
			nominee = NominatedUser.find_by :id => params[:id]
			nominee.destroy!

			redirect_to admin_dashboard_path
		else
			redirect_to root
		end
	end
end