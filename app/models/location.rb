class Location < ApplicationRecord
  has_one :contact, as: :contactable
  
  validates :name, presence: true, uniqueness: true
end
