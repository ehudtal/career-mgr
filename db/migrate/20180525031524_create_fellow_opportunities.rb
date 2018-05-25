class CreateFellowOpportunities < ActiveRecord::Migration[5.2]
  def change
    create_table :fellow_opportunities do |t|
      t.date :secured_on
      t.text :staff_notes
      t.integer :fellow_id
      t.integer :opportunity_id
      t.integer :opportunity_stage_id

      t.timestamps
    end
    
    add_index :fellow_opportunities, :opportunity_stage_id
    add_index :fellow_opportunities, [:fellow_id, :opportunity_id], unique: true
  end
end
