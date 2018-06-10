class Contact < ApplicationRecord
  belongs_to :contactable, polymorphic: true
  
  validates :contactable_id, :contactable_type, presence: true
  validates :contactable_id, uniqueness: {scope: :contactable_type}
  
  validates :url, url: {ensure_protocol: true}, allow_blank: true
end
