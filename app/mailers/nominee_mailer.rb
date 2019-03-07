class NomineeMailer < ApplicationMailer
	default from: 'no-reply@erasmus-eid4u.dit.upm.es'

	def user_creation_email(nominee, url)
		@nominee = nominee
		puts @nominee.registration_token
		@nominee_url = url +"/register/"+ @nominee.registration_token
		mail(to: @nominee.email, subject: 'You have been nominated to ETSIT-UPM in the framework of a mobility programme', encrypt: true)
	end
end
