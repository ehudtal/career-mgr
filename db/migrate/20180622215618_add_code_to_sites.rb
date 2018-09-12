class AddCodeToSites < ActiveRecord::Migration[5.2]
  def change
    add_column :sites, :code, :string
    add_index :sites, :code
  end
end
