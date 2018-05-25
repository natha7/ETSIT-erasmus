class AddStudentApplicationForm < ActiveRecord::Migration[5.2]
  def change
  	create_table :student_application_form do |t|
  		t.integer :step

  		#Personal Data
  		t.string :first_name
  		t.string :family_name
  		t.date :birth_date
  		t.string :born_place
  		t.string :nationality
  		t.string :sex
  		t.string :address
  		t.string :permanent_adress
  		t.string :telephone
  		t.string :mobile_telephone

  		#Sending Institution
  		t.string :inst_sending_name
  		t.string :erasmus_code
  		t.string :inst_or_dep_coord
  		t.string :inst_adress
  		t.string :inst_telephone
  		t.string :inst_telephone2
  		t.string :inst_email

  		#Academic Year
  		t.string :academic_year
  		t.string :programme
  		t.string :field_of_study

  		#Purpose of Stay
  		t.string :project_work
  		t.string :under_grad_courses
  		t.string :reasons_abroad

  		#Language Competence
  		t.string :mother_tonge
  		t.string :language_instruction

  		#Previous And Current Studies
  		t.string :current_diploma_degree
  		t.string :year_attended
  		t.string :specialization_area
  		t.boolean :already_study_abroad
  		t.string :where_study_abroad
  		t.string :where_institution_abroad
  	end

  	create_table :language do |t|
  		t.belongs_to :student_application_form, index: true
  		t.string :name
  		t.boolean :currently_studying
  		t.boolean :able_follow_lectures
  		t.boolean :able_follow_lectures_extra_preparation
  	end

  	create_table :work_experience do |t|
  		t.belongs_to :student_application_form, index: true
  		t.string :type
  		t.string :firm_organisation
  		t.string :dates
  		t.string :country
  	end

  	create_table :nominated_users do |t|
  		t.string :name
  		t.string :university
  		t.string :period
  		t.string :email
  		t.string :registration_token
  	end
    add_index :nominated_users, :registration_token, unique: true

  end
end
