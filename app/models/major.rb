class Major < ApplicationRecord
  has_and_belongs_to_many :fellows
  has_and_belongs_to_many :opportunities

  belongs_to :parent, class_name: 'Major', optional: true
  has_many :children, class_name: 'Major', foreign_key: 'parent_id'
  
  validates :name, presence: true, uniqueness: true
end
