class Employer < ApplicationRecord
  has_many :opportunities
  
  has_and_belongs_to_many :coaches
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :locations
  
  accepts_nested_attributes_for :industries

  validates :name, presence: true, uniqueness: true
end
