class UserMailer < ActionMailer::Base
	
	def finished_application_mail_to_admins(user)
		@user = user
		admins = User.where(:role => "admin")
		emails = admins.collect(&:email).join(",")
		mail(to: emails , subject: '#{@user.first_name} has finished its application', encrypt: true)
	end

	def reviewed_application_mail(user)
		@user = user
		mail(to: @user.email , subject: '#{@user.first_name} your application has been reviewed', encrypt: true)
	end
end	