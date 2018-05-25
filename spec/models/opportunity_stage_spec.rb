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
  
  describe 'validating uniqueness' do
    subject { create :opportunity_stage }
    it { should validate_uniqueness_of :name }
  end
end
