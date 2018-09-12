class AddJoinTableForFellowOpportunityTypes < ActiveRecord::Migration[5.2]
  def change
    create_join_table :fellows, :opportunity_types do |t|
      t.index :fellow_id
      t.index :opportunity_type_id
    end
  end
end
