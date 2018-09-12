class Location < ApplicationRecord
  belongs_to :locateable, polymorphic: true

  has_one :contact, as: :contactable, dependent: :destroy
  accepts_nested_attributes_for :contact
  
  has_and_belongs_to_many :opportunities, dependent: :destroy
  
  validates :name, uniqueness: {scope: [:locateable_id, :locateable_type]}, unless: Proc.new{|location| location.name.blank?}
  
  def label
    "#{name}: #{contact.address_1} #{contact.city}, #{contact.state}"
  end
end
