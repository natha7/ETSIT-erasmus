class AddStudentApplicationForm < ActiveRecord::Migration[5.2]
  def change

		create_table :project_settings do |t|
#			t.integer  :singleton_guard
			t.string :academic_years
			t.string :current_academic_year
			t.string :next_academic_year
			t.string :deadline_first_semeter
			t.string :deadline_second_semester
			t.string :deadline_double_degree
			t.string :mobility_programmes
			t.timestamps
		end
#		add_index(:project_settings, :singleton_guard, :unique => true)

  	create_table :student_application_forms do |t|
  		t.integer :step, :default => 1

  		#Sending Institution
  		t.string :inst_sending_name, :default => ""
      t.string :inst_adress
      t.string :school_family_dpt
  		t.string :erasmus_code
  		t.string :dept_coordinator
      
      t.string :contact_person
  		t.string :inst_telephone
  		t.string :inst_email

  		#Academic Year
  		t.string :academic_year, :default => ""
  		t.string :programme
  		t.string :field_of_study

  		#Purpose of Stay
  		t.string :purpose_of_stay
			t.string :other_purpose

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
      # Work Experience
      t.boolean :no_work_experience
      t.timestamps
  	end
    
    add_reference :student_application_forms, :user, index: true

		create_table :learning_agreement_subjects do |t|
			t.integer :code
			t.string :subject
			t.string :degree
			t.float :ects
		end

		add_reference :learning_agreement_subjects, :user, index: true

  	create_table :languages do |t|
  		t.string :name
  		t.boolean :currently_studying
  		t.boolean :able_follow_lectures
  		t.boolean :able_follow_lectures_extra_preparation
  	end

    add_reference :languages, :student_application_form, index: true

  	create_table :work_experiences do |t|
  		t.string :work_kind
  		t.string :firm_organisation
  		t.date :from
      t.date :to
  		t.string :country
  	end

    add_reference :work_experiences, :student_application_form, index: true

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
