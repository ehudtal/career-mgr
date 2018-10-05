class AddPortalUserIdToFellows < ActiveRecord::Migration[5.2]
  def change
    add_column :fellows, :portal_user_id, :integer
  end
end
