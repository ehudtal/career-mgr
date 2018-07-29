require 'rails_helper'

RSpec.describe FellowOpportunity, type: :model do
  
  ##############
  # Associations
  ##############

  it { should belong_to :fellow }
  it { should belong_to :opportunity }
  it { should belong_to :opportunity_stage }
  
  it { should have_one :access_token }
  
  it { should have_many :comments }
  it { should have_many :logs }
  
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
    let(:name_original) { 'original stage name' }
    let(:name_new) { 'new stage name' }
    let(:name_rejected) { 'rejected' }
    
    let(:stage_original) { create :opportunity_stage, name: name_original, position: 0 }
    let(:stage_new) { create :opportunity_stage, name: name_new, position: 1 }
    let(:stage_rejected) { create :opportunity_stage, name: name_rejected, position: 2 }

    let(:fellow_opportunity) { create :fellow_opportunity, opportunity_stage: stage_original }
    
    before do
      fellow_opportunity; stage_new; stage_rejected
      fellow_opportunity.update opportunity_stage_id: stage_original.id
    end
    
    def expect_stage opp_stage
      expect(fellow_opportunity.opportunity_stage).to eq(opp_stage)
    end
    
    def expect_log stage_name
      expect(fellow_opportunity.logs.last.status).to eq(stage_name)
    end

    describe '#stage' do
      it "returns the name of the opportunity stage" do
        expect_stage(stage_original)
      end
    end

    describe '#stage=(stage_name)' do
      before do
        fellow_opportunity.stage = name_new
        fellow_opportunity.reload
      end
      
      it "sets the opportunity_stage based on name" do
        expect_stage(stage_new)
      end
    
      it "creates a log record when stage is set" do
        expect_log(name_new)
      end
    
      describe 'with special status "no change"' do
        let(:name_new) { 'no change' }
        
        it "stays as current stage" do
          expect_stage(stage_original)
        end
        
        it "creates a log record of 'no change'" do
          expect_log('no change')
        end
      end
    
      describe 'with special status "next"' do
        let(:name_new) { 'next' }
        
        it "moves to next stage" do
          expect_stage(stage_new)
        end
        
        it "creates a log record of skipped stage" do
          expect_log(name_new)
        end
      end
    
      describe 'with special status "skip"' do
        let(:name_new) { 'skip' }
        
        it "moves to next stage" do
          expect_stage(stage_new)
        end
        
        it "creates a log record of skipped stage" do
          expect_log("skipped to: #{name_new}")
        end
      end
    
      describe 'with special status "declined"' do
        let(:name_new) { 'declined' }
        
        it "sets stage to 'rejected'" do
          expect_stage(stage_rejected)
        end
        
        it "creates a log record of 'rejected'" do
          expect_log(name_rejected)
        end
      end
    end
  end
  
  describe '#log(status)' do
    it "creates a candidate_log record with the given status" do
      fellow_opportunity = create :fellow_opportunity
      status_message = 'this is a status message'
      
      fellow_opportunity.log status_message
      expect(fellow_opportunity.logs.last.status).to eq(status_message)
    end
  end
end
