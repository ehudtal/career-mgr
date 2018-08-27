require 'rails_helper'

RSpec.describe OpportunityType, type: :model do
  ##############
  # Associations
  ##############
  
  it { should have_many :opportunities }
  
  #############
  # Validations
  #############

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:position) }
  
  describe 'validating uniqueness' do
    before { create :opportunity_type }
    
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:position) }
  end
end
