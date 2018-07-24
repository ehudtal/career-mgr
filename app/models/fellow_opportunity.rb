class FellowOpportunity < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :fellow
  belongs_to :opportunity
  belongs_to :opportunity_stage
  
  has_many :comments, as: :commentable
  
  validates :fellow_id, presence: true, uniqueness: {scope: :opportunity_id}
  validates :opportunity_id, presence: true
  validates :opportunity_stage_id, presence: true
  
  def stage
    opportunity_stage.name
  end
  
  def stage= stage_name
    self.update opportunity_stage: OpportunityStage.find_by(name: stage_name)
  end
end
