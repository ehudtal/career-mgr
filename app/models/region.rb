class Region < ApplicationRecord
  has_many :opportunities
  
  validates :name, presence: true, uniqueness: true
end
