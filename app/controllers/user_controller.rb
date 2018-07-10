require "prawn"

class UserController < ApplicationController
	before_action :authenticate_user!, except: [:digital_certificate, :token_registration, :create_user, :register_with_email_and_password, :register_with_eidas]

	### ADMIN
	def admin_dashboard
		render "users/admin_dashboard"
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

	def file_upload
		puts params[:user]
		unless params[:user].blank?
			keys = params[:user].keys
			current_user.assign_attributes({keys[0] => params[:user][keys[0]]})
			unless current_user.save
				flash[:error] = current_user.errors.full_messages.to_sentence
			end
		else 
			flash[:error] = "File not valid"
		end
		redirect_to user_dashboard_path
	end
	def file_upload_ajax
		puts params[:user]
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

 	


	def generate_pdf
		send_data create_pdf(current_user), :filename => "application_form.pdf", :type => "application/pdf"
	end



	private 
	def create_pdf(user)
	    Prawn::Document.new do
	    	steps = user.student_application_form
	    	puts steps
	    	def check_field(field)
				text (field.blank? ? "<em>Empty</em>" : field), :inline_format => true 
			end

	    	def label(field)
				text ("<b>#{field}</b>"), :inline_format => true 
			end		

			def title(field)	
				text ("<b>#{field}</b>"), :inline_format => true, :size => 24
			end

	    	title("Sending Institution")
	    	label("Name")
	    	check_field(steps.inst_sending_name)
	    	label("Erasmus Code")
	    	check_field(steps.erasmus_code)
	    	label("Dept. Coordinator")
	    	check_field(steps.dept_coordinator)
	    	label("School Family Dept")
	    	check_field(steps.school_family_dpt)
	    	label("Institution Address")
	    	check_field(steps.inst_adress)
	    	label("Contact person")
	    	check_field(steps.contact_person)
	    	label("Institution phone")
	    	check_field(steps.inst_telephone)
	    	label("Institution e-mail")
	    	check_field(steps.inst_email)
	    	start_new_page


	    	title("Purpose of stay")
	    	label("Project work")
			check_field(steps.project_work)
	    	label("Under Graduate Courses")
			check_field(steps.under_grad_courses)
	    	label("Graduate Courses")
			check_field(steps.graduate_courses)
			start_new_page

			title("Study year")
			label("Academic year")
			check_field(steps.academic_year)
			label("Programme")
			check_field(steps.programme)
			label("Field of study")
			check_field(steps.field_of_study)

	    end.render 
	end

	def file_delete
		case params[:attachment]
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

end
