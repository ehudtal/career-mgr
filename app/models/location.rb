class Location < ApplicationRecord
  belongs_to :locateable, polymorphic: true

  has_one :contact, as: :contactable
  accepts_nested_attributes_for :contact
  
  has_and_belongs_to_many :opportunities
  
  validates :name, presence: true, uniqueness: {scope: [:locateable_id, :locateable_type]}
  
  def label
    "#{name}: #{contact.address_1} #{contact.city}, #{contact.state}"
  end
end
