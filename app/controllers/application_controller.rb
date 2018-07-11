class ApplicationController < ActionController::Base

	def after_sign_in_path_for(resource)
  		if resource.admin?
  			admin_dashboard_path
  		else
  			user_dashboard_path
  		end
	end

	def validate_admin?
      current_user.admin? ? true : raise_forbidden
  	end

  	def validate_not_user?
  		current_user ? raise_forbidden : true
  	end

  	private

  	def raise_forbidden
  		render(:file => File.join(Rails.root, 'public/403.html'), :status=> 403)
  	end
end
