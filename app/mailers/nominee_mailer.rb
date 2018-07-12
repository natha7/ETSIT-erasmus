class NomineeMailer < ApplicationMailer
	default from: 'no-reply@eid4u.org'

	def user_creation_email(nominee, url)
		@nominee = nominee
		@nominee_url = url + "/register/"+ @nominee.registration_token
		mail(to: @nominee.email, subject: 'You are nominated to ETSIT-UPM Erasmus Programme', encrypt: true)
	end
end
