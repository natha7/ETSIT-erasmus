class AddDuringVariables < ActiveRecord::Migration[5.2]
    def change
        change_table :users do |t|
        t.integer "current_during_la_version"
        t.attachment "acceptance_letter"
        t.attachment "signed_la"
        end
      
      create_table :during_las, force: :cascade do |t|
        t.attachment :payment_letter
        t.attachment :during_la_signed_student
        t.attachment :during_la_signed_host
        t.attachment :during_la_signed_all
        t.string :admin_review_comment
        t.string :student_error_comment
        t.bigint "user_id"
        t.integer "during_la_version"
        t.index ["user_id","during_la_version"], name: "index_during_la_docs_on_user_id_and_version"
      end
    end
  end
  