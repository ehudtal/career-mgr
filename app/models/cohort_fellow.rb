class CohortFellow < ApplicationRecord
  belongs_to :cohort
  belongs_to :fellow
  
  validates :cohort_id, presence: true, uniqueness: {scope: :fellow_id}
  validates :fellow_id, presence: true
end
