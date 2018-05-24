class Site < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
