class Employer < ApplicationRecord
  has_many :opportunities
  has_many :locations, as: :locateable
  
  has_and_belongs_to_many :coaches
  has_and_belongs_to_many :industries
  
  accepts_nested_attributes_for :industries

  validates :name, presence: true, uniqueness: true
end
