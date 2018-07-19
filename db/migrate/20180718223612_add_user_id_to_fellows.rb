class AddUserIdToFellows < ActiveRecord::Migration[5.2]
  def change
    add_column :fellows, :user_id, :integer
    add_index :fellows, :user_id
  end
end
