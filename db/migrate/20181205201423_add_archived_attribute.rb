class AddArchivedAttribute < ActiveRecord::Migration[5.2]
  def change
  	change_table :users do |t|
      t.boolean :archived, :default => false
    end
  end
end
