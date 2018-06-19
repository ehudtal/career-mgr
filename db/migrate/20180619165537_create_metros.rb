class CreateMetros < ActiveRecord::Migration[5.2]
  def change
    create_table :metros do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
    add_index :metros, :code, unique: true
    add_index :metros, :name, unique: true
  end
end
