class EmploymentStatus < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
