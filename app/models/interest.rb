class Interest < ApplicationRecord
  has_and_belongs_to_many :fellows
  has_and_belongs_to_many :opportunities

  validates :name, presence: true, uniqueness: true
end
