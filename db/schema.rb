# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_05_23_122232) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.boolean "currently_studying"
    t.boolean "able_follow_lectures"
    t.boolean "able_follow_lectures_extra_preparation"
    t.bigint "student_application_form_id"
    t.index ["student_application_form_id"], name: "index_languages_on_student_application_form_id"
  end

  create_table "nominated_users", force: :cascade do |t|
    t.string "name"
    t.string "university"
    t.string "period"
    t.string "email"
    t.string "registration_token"
    t.index ["registration_token"], name: "index_nominated_users_on_registration_token", unique: true
  end

  create_table "student_application_forms", force: :cascade do |t|
    t.integer "step", default: 1
    t.string "inst_sending_name"
    t.string "inst_adress"
    t.string "school_family_dpt"
    t.string "erasmus_code"
    t.string "dept_coordinator"
    t.string "contact_person"
    t.string "inst_telephone"
    t.string "inst_email"
    t.string "academic_year"
    t.string "programme"
    t.string "field_of_study"
    t.string "project_work"
    t.string "under_grad_courses"
    t.string "graduate_courses"
    t.string "mother_tongue"
    t.string "language_instruction"
    t.string "current_diploma_degree"
    t.string "year_attended"
    t.string "specialization_area"
    t.boolean "already_study_abroad"
    t.string "where_study_abroad"
    t.string "where_institution_abroad"
    t.boolean "no_work_experience"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_student_application_forms_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "family_name"
    t.date "birth_date"
    t.string "born_place"
    t.string "nationality"
    t.string "sex"
    t.string "permanent_adress"
    t.string "phone_number"
    t.boolean "seeking_degree", default: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "signed_student_application_form_file_name"
    t.string "signed_student_application_form_content_type"
    t.integer "signed_student_application_form_file_size"
    t.datetime "signed_student_application_form_updated_at"
    t.string "motivation_letter_file_name"
    t.string "motivation_letter_content_type"
    t.integer "motivation_letter_file_size"
    t.datetime "motivation_letter_updated_at"
    t.string "curriculum_vitae_file_name"
    t.string "curriculum_vitae_content_type"
    t.integer "curriculum_vitae_file_size"
    t.datetime "curriculum_vitae_updated_at"
    t.string "transcript_of_records_file_name"
    t.string "transcript_of_records_content_type"
    t.integer "transcript_of_records_file_size"
    t.datetime "transcript_of_records_updated_at"
    t.string "learning_agreement_file_name"
    t.string "learning_agreement_content_type"
    t.integer "learning_agreement_file_size"
    t.datetime "learning_agreement_updated_at"
    t.string "valid_insurance_policy_file_name"
    t.string "valid_insurance_policy_content_type"
    t.integer "valid_insurance_policy_file_size"
    t.datetime "valid_insurance_policy_updated_at"
    t.string "ni_passport_file_name"
    t.string "ni_passport_content_type"
    t.integer "ni_passport_file_size"
    t.datetime "ni_passport_updated_at"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "recommendation_letter_1_file_name"
    t.string "recommendation_letter_1_content_type"
    t.integer "recommendation_letter_1_file_size"
    t.datetime "recommendation_letter_1_updated_at"
    t.string "recommendation_letter_2_file_name"
    t.string "recommendation_letter_2_content_type"
    t.integer "recommendation_letter_2_file_size"
    t.datetime "recommendation_letter_2_updated_at"
    t.string "official_gpa_file_name"
    t.string "official_gpa_content_type"
    t.integer "official_gpa_file_size"
    t.datetime "official_gpa_updated_at"
    t.string "english_test_score_file_name"
    t.string "english_test_score_content_type"
    t.integer "english_test_score_file_size"
    t.datetime "english_test_score_updated_at"
    t.integer "role"
    t.integer "progress_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "work_experiences", force: :cascade do |t|
    t.string "work_kind"
    t.string "firm_organisation"
    t.date "from"
    t.date "to"
    t.string "country"
    t.bigint "student_application_form_id"
    t.index ["student_application_form_id"], name: "index_work_experiences_on_student_application_form_id"
  end

end
