require 'rails_helper'

RSpec.describe OpportunityStage, type: :model do
  
  ##############
  # Associations
  ##############
  
  it { should have_many :fellow_opportunities }

  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  it { should validate_presence_of :position }
  it { should validate_presence_of :probability }
  
  it { should validate_numericality_of(:position).only_integer.is_greater_than_or_equal_to(0) }
  
  describe 'validating uniqueness' do
    subject { create :opportunity_stage }
    
    it { should validate_uniqueness_of :name }
    it { should validate_uniqueness_of :position }
  end

  it { should validate_numericality_of(:probability).is_greater_than_or_equal_to(0.0) }
  it { should validate_numericality_of(:probability).is_less_than_or_equal_to(1.0) }
  it { should validate_numericality_of(:probability).allow_nil }
end
