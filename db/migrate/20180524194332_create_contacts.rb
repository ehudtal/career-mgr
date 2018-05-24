class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :phone
      t.string :email
      t.string :url
      t.integer :contactable_id
      t.string :contactable_type

      t.timestamps
    end
    
    add_index :contacts, [:contactable_id, :contactable_type], unique: true
  end
end
