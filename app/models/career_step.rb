class CareerStep < ApplicationRecord
  belongs_to :fellow
  
  validates :name, :description, presence: true
end
