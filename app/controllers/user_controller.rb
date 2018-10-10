class UserController < ApplicationController
	before_action :authenticate_user!, except: [:digital_certificate, :token_registration, :create_user, :register_with_email_and_password, :register_with_eidas]
	before_action :validate_not_user?, only: [:register_with_email_and_password, :register_with_eidas]
	before_action :validate_admin?, only: [:admin_dashboard, :set_user_status, :review_dashboard]

	### ADMIN
	def admin_dashboard
		render "users/admin_dashboard"
	end
	def set_user_status
		user = User.find(params[:user][:id])
		user.progress_status = params[:user][:progress_status]
		if user.progress_status == "accepted"
	  	begin
	     	#UserMailer.reviewed_application_mail(current_user).deliver_now
	     	url = request.base_url + RELATIVE_URL
			UserMailer.reviewed_application_mail(url, user).deliver_now
		rescue
	     	flash[:error] = "E-mail to #{user.email} could not be sent"
	    end
		end
		user.save!
		redirect_to admin_dashboard_path
	end

	### USER
	def user_dashboard
		render "users/user_dashboard"
	end

	def review_dashboard
		render "users/review_dashboard"
	end

	def register_with_email_and_password
		@nominated_user = NominatedUser.find_by :registration_token => params[:token_registration]
		unless @nominated_user.blank?
			render "users/registration"
		end
	end

	def register_with_eidas
		#do things with eidas then render
		render "users/registration"
	end

	def finish_app_form
		user = current_user
	    if user.role == "user" && user.progress_status == "in_process" && user.percentage_num.to_i == 100
	      user.progress_status = :finished
	     begin
	     	url = request.base_url + RELATIVE_URL
	      	UserMailer.finished_application_mail_to_admins(url, current_user).deliver_now
      	rescue
	      	flash[:error] = (flash[:error].blank? ?  "" : (flash[:error] + "\n" )) + "E-mail to #{user.email} could not be sent"
        end
	      user.save!
	    end
	    redirect_to user_dashboard_path
  	end

	def update_personal_data
		current_user.assign_attributes(params.require(:user).permit(
				 :first_name,
				 :family_name,
				 :birth_date,
				 :born_place,
				 :nationality,
				 :sex,
				 :permanent_adress,
				 :phone_number
			))
		
		current_user.student_application_form.step = 1
		from_ball = params[:from_ball] == "true"
		if current_user.save
			if !from_ball
				redirect_to student_application_form_path
			else
				redirect_to student_application_form_path(:from_ball => from_ball)
			end

		else
			flash[:error] = current_user.errors.full_messages.to_sentence
			redirect_back fallback_location: root_path
		end
		
	end

	def file_upload
		unless params[:user].blank?
			keys = params[:user].keys
			if keys.length == 1
				current_user.assign_attributes({keys[0] => params[:user][keys[0]]})
			elsif keys.length == 2 and keys[0] == "ni_type"
				current_user.assign_attributes({keys[0] => params[:user][keys[0]], keys[1] => params[:user][keys[1]]})
			end
			unless current_user.save
				flash[:error] = current_user.errors.full_messages.to_sentence
			end
		else 
			flash[:error] = "File not valid"
		end
		redirect_to user_dashboard_path
	end

	def submit_la
		unless params[:user].blank?
			unless params[:user][:learning_agreement_subjects].blank?
				current_user.learning_agreement_subjects.destroy_all
				subjects = params[:user][:learning_agreement_subjects]
				subjects.each do |subject|
					if !subject[:subject].blank? and !subject[:code].blank? and !subject[:degree].blank? and !subject[:ects].blank?
						sj = LearningAgreementSubject.new
						sj.subject = subject[:subject]
						sj.code = subject[:code]
						sj.degree = subject[:degree]
						sj.ects = subject[:ects]
						current_user.learning_agreement_subjects << sj
						sj.save!
					end
				end

			end
			unless current_user.save
				head :forbidden
				return
			end
		else
			head :forbidden
			return
		end
		render :json => {  }
	end

	def file_upload_ajax
		url = ""
		unless params[:user].blank?
			keys = params[:user].keys
			current_user.assign_attributes({keys[0] => params[:user][keys[0]]})
			unless current_user.save
				head :forbidden
				return
			end
			url = current_user.send(keys[0])  
		else 
			head :forbidden
			return
		end
		render :json => {:url => url }
	end

	def file_delete
		case params[:attachment]
		when "signed_student_application_form"
			current_user.signed_student_application_form = nil
			current_user.save!
		when "motivation_letter"
			current_user.motivation_letter = nil
			current_user.save!
		when "curriculum_vitae"
			current_user.curriculum_vitae = nil
			current_user.save!
		when "valid_insurance_policy"
			current_user.valid_insurance_policy = nil
			current_user.save!
		when "ni_passport"
			current_user.ni_passport = nil
			current_user.save!
		when "transcript_of_records"			
			current_user.transcript_of_records = nil
			current_user.save!
		when "learning_agreement"
			current_user.learning_agreement = nil
			current_user.save!
		when "photo"
			current_user.photo = nil
			current_user.save!
		when "recommendation_letter_1"
			current_user.recommendation_letter_1 = nil
			current_user.save!
		when "recommendation_letter_2"			
			current_user.recommendation_letter_2 = nil
			current_user.save!
		when "official_gpa"
			current_user.official_gpa = nil
			current_user.save!
		when "english_test_score"
			current_user.english_test_score = nil
			current_user.save!
		else
			flash[:error] = "There was an error"
		end

		redirect_to user_dashboard_path
	end

	def massive_email
		users = User.all.reject{|t| t.role == "admin"}
		emails = ""
		users.each do |user|
			emails += "#{user.email},"
		end
		redirect_to "mailto:?bcc=#{emails}&subject=ETSIT-UPM International Office&body=Dear Students,%0A%0a"
	end

	def generate_csv
		require 'csv'
		users = User.all.reject{|t| t.role == "admin"}
		csv_string = CSV.generate(:col_sep => ";") do |csv|
			csv << ["user", "email", "institution", "academic_year", "programme", "subject", "code", "degree", "created_at", "last_updated"]
			users.each do |user|
 				user.learning_agreement_subjects.each do |s|
					csv << [user.id, user.email, user.student_application_form.inst_sending_name, user.student_application_form.academic_year, user.student_application_form.programme, s.subject, s.code, s.degree, user.created_at.in_time_zone("Madrid").strftime("%d-%m-%Y %r"), user.updated_at.in_time_zone("Madrid").strftime("%d-%m-%Y %r")]
				end
			end
		end
		send_data csv_string , :filename => 'students.csv'
	end
end
