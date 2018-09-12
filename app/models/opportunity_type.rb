class OpportunityType < ApplicationRecord
  has_many :opportunities
  
  has_and_belongs_to_many :fellows
  
  validates :name, :position, presence: true, uniqueness: true
  
  class << self
    def types
      return @types if defined?(@types)
      @types = YAML.load(File.read("#{Rails.root}/config/opportunity_types.yml"))
    end
  end
end
