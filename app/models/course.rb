class Course < ApplicationRecord
  belongs_to :site
  
  validates :site_id, presence: true, uniqueness: {scope: [:semester, :year]}
end
