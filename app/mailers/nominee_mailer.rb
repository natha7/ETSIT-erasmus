class NomineeMailer < ApplicationMailer
	default from: 'confirmation@etsit.upm.es'

	def user_creation_email(nominee)
		@nominee = nominee
		@nominee_url = user_creation_path + @nominee.registration_token
		 mail(to: @nominee.email, subject: 'You are nominated').deliver_now
	end
end
