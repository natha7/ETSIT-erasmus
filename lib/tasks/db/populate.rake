namespace :db do
	#rake db:create_admin user= password=
	desc "Populating database"
	task :populate => :environment do 
		user = User.new
		user.email = "admin@eid4u.org"
		user.password = "demonstration"
		user.role = :admin
		user.first_name = "Administrator"
		user.family_name = "of the application"
		user.save!

		pupil = User.new
		pupil.email = "pupil@eid4u.org"
		pupil.password = "demonstration"
		pupil.first_name = "Demo"
		pupil.family_name = "Family Name"
		pupil.sex = "Male"
		pupil.birth_date = Date.parse("Dec 8 1990")
		pupil.permanent_adress = "Fake Street 123"
		pupil.nationality = "Spain"
		pupil.phone_number = "636363636"
		pupil.save!
		puts 'Created'

	end
end
