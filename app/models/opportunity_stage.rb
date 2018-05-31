class OpportunityStage < ApplicationRecord
  has_many :fellow_opportunities
  
  validates :name, presence: true, uniqueness: true
  validates :probability, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0, allow_nil: true}
end
