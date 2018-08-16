class CareerStep < ApplicationRecord
  belongs_to :fellow
  
  validates :name, :description, presence: true
  
  scope :completed, -> { where(completed: true) }
  
  default_scope { order(position: :asc) }
end
