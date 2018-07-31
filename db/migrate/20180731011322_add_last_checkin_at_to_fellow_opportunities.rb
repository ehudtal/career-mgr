class AddLastCheckinAtToFellowOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :fellow_opportunities, :last_contact_at, :datetime
    FellowOpportunity.update_all last_contact_at: Time.now
  end
end
