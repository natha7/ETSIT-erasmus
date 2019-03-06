class NominatedUserController < ApplicationController
	before_action :authenticate_user!, except: [:register]
	# before_action :validate_not_user?, only: [:register]
	before_action :validate_admin?, only: [:create_nominee, :resend_email, :delete_nominee]

	def create_nominee
		nominee = NominatedUser.new
		nominee.email = params[:email]
		unless !params[:email].blank? and nominee.save 
			flash[:error] = nominee.errors.full_messages.to_sentence
			redirect_to admin_dashboard_path + "?nominees=true"
		else
			url = request.base_url + RELATIVE_URL
			begin  
			   NomineeMailer.user_creation_email(nominee, url).deliver_now
			rescue EOFError,
					IOError,
					TimeoutError,
					Errno::ECONNRESET,
					Errno::ECONNABORTED,
					Errno::EPIPE,
					Errno::ETIMEDOUT,
					Net::SMTPAuthenticationError,
					Net::SMTPServerBusy,
					Net::SMTPSyntaxError,
					Net::SMTPUnknownError,
					OpenSSL::SSL::SSLError => e
				flash[:error] = "E-mail to #{nominee.email} could not be sent"
			end  
			redirect_to admin_dashboard_path + "?nominees=true"

		end
	end

	def create_nominee_multiple
		# sonsoleslp@gmail.com;sonsoleslp@hotmail.com;slopez@dit.upm.es
		emails = params[:email].split(/[\s,\n;]/).reject { |c| c.empty? or !c.include? "@" }
		emails.each do |email|
			nominee = NominatedUser.new
			nominee.email = email
			unless !email.blank? and nominee.save 
				flash[:error] = (flash[:error].blank? ?  "" : (flash[:error] + "\n" )) + nominee.errors.full_messages.to_sentence
			else
				url = request.base_url + RELATIVE_URL
				begin  
				   NomineeMailer.user_creation_email(nominee, url).deliver_now
				rescue
					flash[:error] = (flash[:error].blank? ?  "" : (flash[:error] + "\n" )) + "E-mail to #{email} could not be sent"
				end  
			end
		end
		redirect_to admin_dashboard_path + "?nominees=true"
	end

	def resend_email
		nominee = NominatedUser.find_by :id => params[:id]
		nominee.regenerate_registration_token
		url = request.base_url + RELATIVE_URL
		begin  
		   NomineeMailer.user_creation_email(nominee, url).deliver_now
		rescue  
			flash[:error] = "E-mail to #{nominee.email} could not be sent"
		end  
	end

	def delete_nominee
			nominee = NominatedUser.find_by :id => params[:id]
			nominee.destroy!

			redirect_to admin_dashboard_path + "?nominees=true"
	end

	def register
		if !current_user.blank?
			redirect_to(:root)
		else
			@nominee = NominatedUser.find_by(:registration_token => params[:token_registration])
			if @nominee.blank?
	        	redirect_to(:root)
			else
				@post_params = {}
				@login_url = ""
				node_command = Terrapin::CommandLine.new("node -e 'require(\"./vendor/saml2-node/saml2-gateway.js\").getAuthnRequest()'")
				begin
				    	@post_params["SAMLRequest"] = node_command.run
				    	@post_params["RelayState"] = "MyRelayState"
				    	# @post_params["country"] = "ES"
				    	@login_url = CONFIG["idp_options"]["sso_login_url"]
				rescue Terrapin::ExitStatusError => e
					puts e.message
				end
				session[:nominee] = @nominee.email

				render "users/register_choice"
			end
		end
	end
end