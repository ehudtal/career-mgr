class FellowOpportunity < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :fellow
  belongs_to :opportunity
  belongs_to :opportunity_stage
  
  has_one :access_token, as: :owner
  
  has_many :comments, as: :commentable
  has_many :logs, class_name: 'CandidateLog', foreign_key: :candidate_id
  
  validates :fellow_id, presence: true, uniqueness: {scope: :opportunity_id}
  validates :opportunity_id, presence: true
  validates :opportunity_stage_id, presence: true
  
  def log message
    logs.create status: message
  end
  
  def stage
    opportunity_stage.name
  end
  
  def stage= stage_name
    stage_name = 'rejected' if stage_name == 'declined'
    
    case stage_name
    when 'no change'
      log 'no change'

    when 'next'
      next_stage = next_opportunity_stage

      self.update opportunity_stage: next_stage
      log stage_name

    when 'skip'
      next_stage = next_opportunity_stage

      self.update opportunity_stage: next_stage
      log "skipped to: #{next_stage.name}"

    else
      self.update opportunity_stage: OpportunityStage.find_by(name: stage_name)
      log stage_name
    end
  end
  
  private
  
  def next_opportunity_stage
    OpportunityStage.find_by(position: opportunity_stage.position + 1)
  end
end
