class Site < ApplicationRecord
  has_many :courses, dependent: :destroy
  
  has_one :location, as: :locateable
  accepts_nested_attributes_for :location

  validates :name, presence: true, uniqueness: true
end
