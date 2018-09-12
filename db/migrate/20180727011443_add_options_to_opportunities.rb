class AddOptionsToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :steps, :text
  end
end
