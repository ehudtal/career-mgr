class CohortFellow < ApplicationRecord
  belongs_to :cohort
  belongs_to :fellow
  
  validates :cohort_id, presence: true, uniqueness: {scope: :fellow_id}
  validates :fellow_id, presence: true
  
  validates :grade, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0, allow_nil: true}
  validates :attendance, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0, allow_nil: true}

  validates :nps_response, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 10, allow_nil: true, only_integer: true}
  validates :endorsement, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 10, allow_nil: true, only_integer: true}
  validates :professionalism, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 10, allow_nil: true, only_integer: true}
  validates :teamwork, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 10, allow_nil: true, only_integer: true}
end
