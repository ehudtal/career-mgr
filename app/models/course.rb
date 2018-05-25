class Course < ApplicationRecord
  belongs_to :site
  
  has_many :cohorts
  
  validates :site_id, presence: true, uniqueness: {scope: [:semester, :year]}
end
