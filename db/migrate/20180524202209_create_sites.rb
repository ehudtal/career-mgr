class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.string :name

      t.timestamps
    end
    
    add_index :sites, :name, unique: true
  end
end
