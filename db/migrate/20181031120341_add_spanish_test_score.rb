class AddSpanishTestScore < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.attachment :spanish_test_score
    end
  end
end
