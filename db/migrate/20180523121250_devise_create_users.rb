# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      t.string :first_name
      t.string :family_name
      t.date :birth_date
      t.string :born_place
      t.string :nationality
      t.string :sex
      t.string :permanent_adress
      t.string :phone_number
      t.boolean :seeking_degree, :default => false

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.attachment :motivation_letter
      t.attachment :curriculum_vitae
      t.attachment :transcript_of_records
      t.attachment :learning_agreement
      t.attachment :valid_insurance_policy
      t.attachment :ni_passport
      t.attachment :photo

      #Aditional
      t.attachment :recommendation_letter_1
      t.attachment :recommendation_letter_2
      t.attachment :official_gpa
      t.attachment :english_test_score
      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at
      t.integer :role
      t.integer :progress_status


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
