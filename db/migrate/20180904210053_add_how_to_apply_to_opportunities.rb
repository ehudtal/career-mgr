class AddHowToApplyToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :how_to_apply, :text
  end
end
