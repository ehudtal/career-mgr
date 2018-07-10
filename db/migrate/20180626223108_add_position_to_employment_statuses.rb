class AddPositionToEmploymentStatuses < ActiveRecord::Migration[5.2]
  def change
    add_column :employment_statuses, :position, :integer
    add_index :employment_statuses, :position, unique: true
  end
end
