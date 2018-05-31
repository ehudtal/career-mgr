class CreateOpportunities < ActiveRecord::Migration[5.2]
  def change
    create_table :opportunities do |t|
      t.string :name
      t.text :description
      t.integer :employer_id

      t.timestamps
    end
    
    add_index :opportunities, :employer_id
  end
end
