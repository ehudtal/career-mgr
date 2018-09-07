class AddCityStateToPostalCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :postal_codes, :city, :string
    add_column :postal_codes, :state, :string
    add_index :postal_codes, :state
  end
end
