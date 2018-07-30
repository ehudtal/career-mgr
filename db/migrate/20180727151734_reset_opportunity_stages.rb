class ResetOpportunityStages < ActiveRecord::Migration[5.2]
  def change
    OpportunityStage.destroy_all
    
    OpportunityStage.create!([
      {position: 0,  probability: 0.01, togglable: false, name: 'notified'},
      {position: 1,  probability: 0.05, togglable: false, name: 'interested'},
      {position: 2,  probability: 0.0,  togglable: false, name: 'not interested'},
      {position: 3,  probability: 0.1,  togglable: true,  name: 'researched employer'},

      {position: 4,  probability: 0.15, togglable: true,  name: 'connected with employees'},
      {position: 5,  probability: 0.2,  togglable: true,  name: 'customized application materials'},
      {position: 6,  probability: 0.25, togglable: true,  name: 'submitted application'},
      {position: 7,  probability: 0.3,  togglable: true,  name: 'followed up after application submission'},

      {position: 8,  probability: 0.35, togglable: true,  name: 'scheduled an interview'},
      {position: 9,  probability: 0.4,  togglable: true,  name: 'researched interview process'},
      {position: 10, probability: 0.45, togglable: true,  name: 'practiced for interview'},
      {position: 11, probability: 0.5,  togglable: true,  name: 'attended interview'},
      {position: 12, probability: 0.6,  togglable: true,  name: 'followed up after interview'},

      {position: 13, probability: 0.9,  togglable: true,  name: 'received offer'},
      {position: 14, probability: 0.95, togglable: true,  name: 'submitted counter-offer'},
      {position: 15, probability: 1.0,  togglable: true,  name: 'accepted offer'},
      {position: 16, probability: 0.0,  togglable: false, name: 'rejected'}
    ])
    
    initial_stage_id = OpportunityStage.find_by(position: 0).id
    FellowOpportunity.update_all(opportunity_stage_id: initial_stage_id)
  end
end
