class AddEidasIdentifier < ActiveRecord::Migration[5.2]
  def change
   change_table :users do |t|
      t.string :person_identifier, :default => ""
    end
  end
end
