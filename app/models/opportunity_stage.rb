class OpportunityStage < ApplicationRecord
  has_many :fellow_opportunities
  
  validates :name, presence: true, uniqueness: true
end
