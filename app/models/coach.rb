class Coach < ApplicationRecord
  has_one :contact, as: :contactable
  
  has_and_belongs_to_many :cohorts
  has_and_belongs_to_many :employers
  
  validates :name, presence: true, uniqueness: true
end
