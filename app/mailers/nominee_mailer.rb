class NomineeMailer < ApplicationMailer
	default from: 'confirmation@etsit.upm.es'

	def user_creation_email(id)
		@nominee = NominatedUser.find_by(:id => id)
		@nominee_url = user_creation_path + @nominee.registration_token
	end
end
