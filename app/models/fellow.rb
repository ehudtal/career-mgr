class Fellow < ApplicationRecord
  has_one :contact, as: :contactable
  
  has_many :cohort_fellows
  has_many :cohorts, through: :cohort_fellows
  
  validates :first_name, :last_name, presence: true
  
  def cohort
    cohorts.order('id desc').first
  end
end
