class AddAfterAttributes < ActiveRecord::Migration[5.2]
  def change
  	change_table :users do |t|
      t.attachment :tor
      t.attachment :attendance_certificate
    end
  end
end
