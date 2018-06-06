class AddLocateableColumnsToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :locateable_id, :integer
    add_column :locations, :locateable_type, :string
    
    add_index :locations, [:locateable_id, :locateable_type]
  end
end
