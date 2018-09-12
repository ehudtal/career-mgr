class Course < ApplicationRecord
  belongs_to :site
  
  has_many :cohorts
  
  VALID_SEMESTERS = ['Fall', 'Spring', 'Summer', 'Q1', 'Q2', 'Q3', 'Q4']
  
  validates :site_id, presence: true, uniqueness: {scope: [:semester, :year]}
  validates :semester, inclusion: {in: VALID_SEMESTERS}
  validates :year, numericality: {greater_than: 2010, less_than: 2030, allow_nil: true, only_integer: true}
  
  def label
    "#{semester} #{year}"
  end
end
