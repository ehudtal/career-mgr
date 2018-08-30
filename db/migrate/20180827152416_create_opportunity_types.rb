class CreateOpportunityTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :opportunity_types do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
    add_index :opportunity_types, :name
    add_index :opportunity_types, :position
  end
end
