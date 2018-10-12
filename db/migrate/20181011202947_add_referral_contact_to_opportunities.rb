class AddReferralContactToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :referral_email, :string
  end
end
