class AddTogglableToOpportunityStages < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunity_stages, :togglable, :boolean
    add_index :opportunity_stages, :togglable
  end
end
