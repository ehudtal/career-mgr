require 'rails_helper'

RSpec.describe OpportunityType, type: :model do
  ##############
  # Associations
  ##############
  
  it { should have_many :opportunities }
  
  it { should have_and_belong_to_many :fellows }
  
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
  
  ###############
  # Class methods
  ###############

  describe '::types' do
    subject { OpportunityType.types }
    
    it { should be_an(Array) }
    it { expect(subject.size).to eq(9) }
    it { expect(subject.first).to eq('Internship') }
    it { expect(subject.last).to eq('Volunteer') }
  end
end
