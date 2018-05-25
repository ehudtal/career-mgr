require 'rails_helper'

RSpec.describe OpportunityStage, type: :model do
  
  ##############
  # Associations
  ##############

  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  describe 'validating uniqueness' do
    subject { create :opportunity_stage }
    it { should validate_uniqueness_of :name }
  end
end
