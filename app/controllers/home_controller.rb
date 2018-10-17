class HomeController < ApplicationController

	def filter_double_erasmus
		if request.path.scan(/\/erasmus/).length > 1
			new_path =  request.path.gsub(/^\/erasmus/,"")
			redirect_to new_path
		end

	end

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
