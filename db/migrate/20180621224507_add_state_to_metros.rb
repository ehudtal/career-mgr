class AddStateToMetros < ActiveRecord::Migration[5.2]
  def change
    add_column :metros, :state, :string
    add_index :metros, :state
  end
end
