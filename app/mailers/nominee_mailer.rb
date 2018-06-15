class NomineeMailer < ApplicationMailer
	default from: 'no-reply@eid4u.org'

	def user_creation_email(nominee)
		@nominee = nominee
		@nominee_url = "localhost:3000/register/" + @nominee.registration_token
		 mail(to: @nominee.email, subject: 'You are nominated', encrypt: true)
	end
end
