class AddPublishedBooleanToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :published, :boolean, default: false
    add_index :opportunities, :published
  end
end
