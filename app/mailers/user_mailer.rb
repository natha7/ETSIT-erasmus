class UserMailer < ApplicationMailer
	default from: 'no-reply@eid4u.org'
	
	def finished_application_mail_to_admins(url, user)
	 	@user = user
	 	@url = url
	 	admins = User.where(:role => "admin")
	 	emails = admins.collect(&:email).join(",")
	 	mail(to: emails , subject: @user.first_name +  ' has finished their application', encrypt: true)
	end

	def admin_notify_uploaded_before(url, user)
		@user = user
		@url = url
		mail(to: @user.email , subject: 'Your Acceptance Letter has been uploaded. You can now login to review and download it.', encrypt: true)
	end

	def send_during_la_modifications_mail_to_admins(url, user)
		@user = user
		@url = url
		admins = User.where(:role => "admin")
		emails = admins.collect(&:email).join(",")
		mail(to: emails , subject: @user.first_name +  ' has uploaded their During LA modifications', encrypt: true)
	end

	def accept_during_la_modifications_mail(url, user)
		@user = user
		@url = url
		mail(to: @user.email , subject: 'Your During LA modifications have been accepted. We shall upload your documents soon', encrypt: true)
	end

	def reject_during_la_modifications_mail(url, user)
		@user = user
		@url = url
		mail(to: @user.email , subject: 'Your During LA modifications have been rejected. Please review the International Office\'s comments and change them accordingly', encrypt: true)
	end

	def admin_notify_uploaded_during(url, user)
		@user = user
		@url = url
		mail(to: @user.email , subject: 'Your During LA documents have been uploaded. You can now login to review and download them.', encrypt: true)
	end

	def user_notify_uploaded_during(url, user)
		@user = user
		@url = url
		admins = User.where(:role => "admin")
		emails = admins.collect(&:email).join(",")
		mail(to: emails , subject: @user.first_name +  ' has uploaded their During LA signed by all parties', encrypt: true)
	end
	
	def dm_wrong_info_mail_to_admins(url, user)
		@user = user
		@url = url
		admins = User.where(:role => "admin")
		emails = admins.collect(&:email).join(",")
		mail(to: emails , subject: @user.first_name +  ' has detected errors on their Payment Letter / signed DM-LA', encrypt: true)
    end
	
	def admin_notify_closed_during(url, user)
		@user = user
		@url = url
		mail(to: @user.email , subject: 'Your During LA document has been accepted and the modifications request has been closed.', encrypt: true)
	end

	def reviewed_application_mail(url, user)
		@url = url
		@user = user
		mail(to: @user.email , subject: 'Your application has been reviewed successfully. Welcome to ETSIT-UPM ', encrypt: true)
	end
end