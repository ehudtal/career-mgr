class OpportunityStage < ApplicationRecord
  has_many :fellow_opportunities
  
  validates :name, presence: true, uniqueness: true
  validates :position, presence: true, uniqueness: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :probability, presence: true, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0, allow_nil: true}
end
