class Industry < ApplicationRecord
  has_and_belongs_to_many :employers
  has_and_belongs_to_many :opportunities
  
  validates :name, presence: true, uniqueness: true
end
