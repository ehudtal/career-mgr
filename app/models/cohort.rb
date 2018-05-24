class Cohort < ApplicationRecord
  has_one :contact, as: :contactable
  belongs_to :course
  
  validates :name, presence: true, uniqueness: {scope: :course_id}
end
