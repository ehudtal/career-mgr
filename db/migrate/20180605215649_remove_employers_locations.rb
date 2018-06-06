class RemoveEmployersLocations < ActiveRecord::Migration[5.2]
  def up
    drop_table :employers_locations
  end
  
  def down
    create_join_table :locations, :employers do |t|
      t.index :location_id
      t.index :employer_id
    end
  end
end
