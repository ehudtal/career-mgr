class Opportunity < ApplicationRecord
  belongs_to :employer
  
  validates :employer_id, presence: true
end
