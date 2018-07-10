class Industry < ApplicationRecord
  has_and_belongs_to_many :employers
  has_and_belongs_to_many :opportunities
  has_and_belongs_to_many :fellows
  
  validates :name, presence: true, uniqueness: true
end
