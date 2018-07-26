class AddApplicationDeadlineToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :application_deadline, :date
  end
end
