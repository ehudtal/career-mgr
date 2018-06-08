class Task < ApplicationRecord
  belongs_to :taskable, polymorphic: true
  
  validates :name, presence: true
end
