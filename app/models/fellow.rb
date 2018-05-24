class Fellow < ApplicationRecord
  has_one :contact, as: :contactable
  
  validates :first_name, :last_name, presence: true
end
