class AddActiveBooleanToFellowOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :fellow_opportunities, :active, :boolean
    add_index :fellow_opportunities, :active
  end
end
