class AddBooleansToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :inbound, :boolean, default: false
    add_index :opportunities, :inbound
    
    add_column :opportunities, :recurring, :boolean, default: false
    add_index :opportunities, :recurring
  end
end
