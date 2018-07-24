class UpdateRoleNamesInUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :admin, :is_admin
    rename_column :users, :fellow, :is_fellow
  end
end
