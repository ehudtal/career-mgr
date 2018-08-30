class AddPositionToRegions < ActiveRecord::Migration[5.2]
  def change
    add_column :regions, :position, :integer
    add_index :regions, :position
  end
end
