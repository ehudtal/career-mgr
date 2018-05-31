class CreateInterests < ActiveRecord::Migration[5.2]
  def change
    create_table :interests do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
    
    add_index :interests, :name, unique: true
  end
end
