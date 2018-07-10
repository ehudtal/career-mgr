class EmploymentStatus < ApplicationRecord
  validates :name, :position, presence: true, uniqueness: true
end
