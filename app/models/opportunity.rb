class Opportunity < ApplicationRecord
  belongs_to :employer
  
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :interests
  has_and_belongs_to_many :locations
  
  validates :employer_id, presence: true
end
