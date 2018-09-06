class AddPriorityToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :priority, :integer
    add_index :opportunities, :priority
  end
end
