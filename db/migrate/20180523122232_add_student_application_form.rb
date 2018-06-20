class AddStudentApplicationForm < ActiveRecord::Migration[5.2]
  def change
  	create_table :student_application_forms do |t|
  		t.integer :step, :default => 1

  		#Sending Institution
  		t.string :inst_sending_name
      t.string :inst_adress
      t.string :school_family_dpt
  		t.string :erasmus_code
  		t.string :dept_coordinator
      
      t.string :contact_person
  		t.string :inst_telephone
  		t.string :inst_email

  		#Academic Year
  		t.string :academic_year
  		t.string :programme
  		t.string :field_of_study

  		#Purpose of Stay
  		t.string :project_work
  		t.string :under_grad_courses
  		t.string :graduate_courses

  		#Language Competence
  		t.string :mother_tongue
  		t.string :language_instruction

  		#Previous And Current Studies
  		t.string :current_diploma_degree
  		t.string :year_attended
  		t.string :specialization_area
  		t.boolean :already_study_abroad
  		t.string :where_study_abroad
  		t.string :where_institution_abroad


      t.timestamps
  	end
    add_reference :student_application_forms, :user, index: true

    #add_foreign_key :users, :student_application_forms
    #add_foreign_key :student_application_forms, :users

  	create_table :languages do |t|
  		t.string :name
  		t.boolean :currently_studying
  		t.boolean :able_follow_lectures
  		t.boolean :able_follow_lectures_extra_preparation
  	end

  	create_table :work_experiences do |t|
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
