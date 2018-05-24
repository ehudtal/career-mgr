class Cohort < ApplicationRecord
  has_one :contact, as: :contactable

  belongs_to :course
  
  has_many :cohort_fellows
  has_many :fellows, through: :cohort_fellows
  
  validates :name, presence: true, uniqueness: {scope: :course_id}
end
