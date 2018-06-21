class AddMsaCodeToPostalCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :postal_codes, :msa_code, :string
  end
end
