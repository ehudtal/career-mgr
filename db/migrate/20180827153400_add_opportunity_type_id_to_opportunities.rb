class AddOpportunityTypeIdToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :opportunity_type_id, :integer
    add_index :opportunities, :opportunity_type_id
  end
end
