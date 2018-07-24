require 'taggable'

class Employer < ApplicationRecord
  include Taggable

  has_many :opportunities, dependent: :destroy
  has_many :locations, as: :locateable, dependent: :destroy
  
  has_and_belongs_to_many :coaches, dependent: :destroy
  
  taggable :industries
  
  accepts_nested_attributes_for :industries

  validates :name, presence: true, uniqueness: true

  def industry_tags
    industries.pluck(:name).join(';')
  end
  
  def industry_tags= tag_string
    self.industry_ids = Industry.where(name: tag_string.split(';')).pluck(:id)
  end
end
