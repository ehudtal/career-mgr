class AddRolesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :fellow, :boolean, default: true
    
    add_index :users, :admin
    add_index :users, :fellow
  end
end
