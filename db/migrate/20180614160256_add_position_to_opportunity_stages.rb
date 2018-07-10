class AddPositionToOpportunityStages < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunity_stages, :position, :integer
  end
end
