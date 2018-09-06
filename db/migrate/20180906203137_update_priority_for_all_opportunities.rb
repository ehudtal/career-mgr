class UpdatePriorityForAllOpportunities < ActiveRecord::Migration[5.2]
  def change
    Opportunity.all.each do |opp|
      opp.send(:set_priority)
      opp.save
    end
  end
end
