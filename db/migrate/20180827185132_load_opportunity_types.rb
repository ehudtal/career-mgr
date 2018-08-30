class LoadOpportunityTypes < ActiveRecord::Migration[5.2]
  def up
    OpportunityType.destroy_all

    OpportunityType.types.each_with_index do |name, position|
      OpportunityType.create name: name, position: position
      print '.'; $stdout.flush
    end
    
    puts
    
    job = OpportunityType.find_by name: 'Job'
    Opportunity.update_all(opportunity_type_id: job.id)
  end
  
  def down
    OpportunityType.destroy_all
    Opportunity.update_all(opportunity_type_id: nil)
  end
end
