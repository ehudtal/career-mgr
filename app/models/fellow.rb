class Fellow < ApplicationRecord
  has_one :contact, as: :contactable
  
  has_many :cohort_fellows
  has_many :cohorts, through: :cohort_fellows
  
  has_and_belongs_to_many :interests
  
  belongs_to :employment_status
  
  validates :first_name, :last_name, :employment_status_id, presence: true
  
  def cohort
    cohorts.order('id desc').first
  end
end
