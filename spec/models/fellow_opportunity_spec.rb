require 'rails_helper'

RSpec.describe FellowOpportunity, type: :model do
  
  ##############
  # Associations
  ##############

  it { should belong_to :fellow }
  it { should belong_to :opportunity }
  it { should belong_to :opportunity_stage }
  
  it { should have_many :comments }
  
  #############
  # Validations
  #############
  
  it { should validate_presence_of :fellow_id }
  it { should validate_presence_of :opportunity_id }
  it { should validate_presence_of :opportunity_stage_id }
  
  describe 'validating uniqueness' do
    subject { create :fellow_opportunity }
    it { should validate_uniqueness_of(:fellow_id).scoped_to(:opportunity_id) }
  end
  
  ##################
  # Instance methods
  ##################

  describe '#stage accessors' do
    let(:stage_name) { 'stage name' }
    let(:opportunity_stage) { create :opportunity_stage, name: stage_name }
    let(:fellow_opportunity) { create :fellow_opportunity }
    
    before { fellow_opportunity; opportunity_stage }

    it "returns the name of the opportunity stage" do
      fellow_opportunity.opportunity_stage = opportunity_stage
      expect(fellow_opportunity.stage).to eq(stage_name)
    end

    it "sets the opportunity_stage based on name" do
      fellow_opportunity.stage = stage_name
      expect(fellow_opportunity.reload.opportunity_stage).to eq(opportunity_stage)
    end
  end
end
