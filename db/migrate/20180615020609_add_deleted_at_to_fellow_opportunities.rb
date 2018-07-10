class AddDeletedAtToFellowOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :fellow_opportunities, :deleted_at, :datetime
    add_index :fellow_opportunities, :deleted_at
  end
end
