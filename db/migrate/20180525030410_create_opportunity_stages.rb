class CreateOpportunityStages < ActiveRecord::Migration[5.2]
  def change
    create_table :opportunity_stages do |t|
      t.string :name
      t.decimal :probability, precision: 8, scale: 4

      t.timestamps
    end
    
    add_index :opportunity_stages, :name, unique: true
  end
end
