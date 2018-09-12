class DefaultToNoRolesForNewUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :is_fellow, false
  end
end
