class FellowOpportunity < ApplicationRecord
  belongs_to :fellow
  belongs_to :opportunity
  belongs_to :opportunity_stage
  
  validates :fellow_id, presence: true, uniqueness: {scope: :opportunity_id}
  validates :opportunity_id, presence: true
  validates :opportunity_stage_id, presence: true
end
