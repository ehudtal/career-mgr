class OpportunityStage < ApplicationRecord
  has_many :fellow_opportunities
  
  validates :name, presence: true, uniqueness: true
  validates :position, presence: true, uniqueness: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :probability, presence: true, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0, allow_nil: true}
  
  scope :togglable, -> { order(position: :asc).where(togglable: true) }
  
  class << self
    def togglable_names
      togglable.pluck(:name)
    end
  end
  
  def content
    return @content if defined?(@content)
    @content = YAML.load(File.read("#{Rails.root}/config/opportunity_stage_content.yml"))[name]
  end
end
