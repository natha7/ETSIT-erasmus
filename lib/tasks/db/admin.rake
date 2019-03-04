namespace :db do
	#rake db:create_admin email= password=
	desc "Create admin Role using email=, password="
	task :create_admin => :environment do 
		user = User.new
		user.email = ENV["email"]
		user.password = ENV["password"]
		user.role = :admin
		user.save!
	end
end
