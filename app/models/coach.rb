class Coach < ApplicationRecord
  has_one :contact, as: :contactable
  
  has_and_belongs_to_many :cohorts
  
  validates :name, presence: true, uniqueness: true
end
