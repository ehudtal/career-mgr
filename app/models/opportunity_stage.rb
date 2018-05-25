class OpportunityStage < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
