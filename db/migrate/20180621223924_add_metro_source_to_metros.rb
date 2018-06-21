class AddMetroSourceToMetros < ActiveRecord::Migration[5.2]
  def change
    add_column :metros, :source, :string
    add_index :metros, :source
  end
end
