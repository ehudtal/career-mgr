class AddEmployerPartnerToEmployers < ActiveRecord::Migration[5.2]
  def change
    add_column :employers, :employer_partner, :boolean, default: false
    add_index :employers, :employer_partner
  end
end
