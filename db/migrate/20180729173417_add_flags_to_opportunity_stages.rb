class AddFlagsToOpportunityStages < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunity_stages, :auto_notify, :boolean, default: true
    add_column :opportunity_stages, :active_status, :boolean, default: true
  end
end
