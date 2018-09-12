class RenameDescriptionToSummaryInOpportunities < ActiveRecord::Migration[5.2]
  def change
    change_table :opportunities do |t|
      t.rename :description, :summary
    end
  end
end
