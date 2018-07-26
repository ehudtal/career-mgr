class AddOwnerFieldsToAccessTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :access_tokens, :owner_id, :integer
    add_column :access_tokens, :owner_type, :string
    
    add_index :access_tokens, [:owner_id, :owner_type]
  end
end
