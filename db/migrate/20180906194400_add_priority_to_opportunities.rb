class AddPriorityToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :priority, :integer, default: 1000
    add_index :opportunities, :priority
  end
end
