class HomeController < ApplicationController
	def index
		unless !current_user.blank?
			respond_to do |format|
				format.html
			end 
		else
			if current_user.admin?
				redirect_to admin_dashboard_path
			else
				redirect_to user_dashboard_path
			end

		end
	end
end
