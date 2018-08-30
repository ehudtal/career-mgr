class AddRegionIdToOpportununities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :region_id, :integer
    add_index :opportunities, :region_id
  end
end
