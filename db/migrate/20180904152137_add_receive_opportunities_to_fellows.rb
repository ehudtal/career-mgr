class AddReceiveOpportunitiesToFellows < ActiveRecord::Migration[5.2]
  def change
    add_column :fellows, :receive_opportunities, :boolean, default: true
    add_index :fellows, :receive_opportunities
  end
end
