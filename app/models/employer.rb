class Employer < ApplicationRecord
  has_many :opportunities, dependent: :destroy
  has_many :locations, as: :locateable, dependent: :destroy
  
  has_and_belongs_to_many :coaches, dependent: :destroy
  has_and_belongs_to_many :industries, dependent: :destroy
  
  accepts_nested_attributes_for :industries

  validates :name, presence: true, uniqueness: true
end
