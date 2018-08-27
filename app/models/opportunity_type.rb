class OpportunityType < ApplicationRecord
  has_many :opportunities
  
  validates :name, :position, presence: true, uniqueness: true
end
