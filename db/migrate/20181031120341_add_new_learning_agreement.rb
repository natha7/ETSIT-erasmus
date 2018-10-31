class AddNewLearningAgreement < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.attachment :learning_agreement_es
    end
  end
end
