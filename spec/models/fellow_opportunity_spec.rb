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
  
  ########
  # Scopes
  ########

  describe 'active/inactive' do
    let(:fellow_opportunity_active) { create :fellow_opportunity, active: true }
    let(:fellow_opportunity_inactive) { create :fellow_opportunity, active: false }
    
    before do
      fellow_opportunity_active; fellow_opportunity_inactive
    end
    
    describe '::active' do
      subject { FellowOpportunity.active }
      
      it { should include(fellow_opportunity_active) }
      it { should_not include(fellow_opportunity_inactive) }
    end
    
    describe '::inactive' do
      subject { FellowOpportunity.inactive }
      
      it { should include(fellow_opportunity_inactive) }
      it { should_not include(fellow_opportunity_active) }
    end
  end
  
  describe 'most_neglected' do
    let(:recent) { create :fellow_opportunity, active: true, last_contact_at: 1.minute.ago }
    let(:neglected) { create :fellow_opportunity, active: true, last_contact_at: 1.year.ago }
    let(:inactive) { create :fellow_opportunity, active: false }
    
    before do
      recent; neglected; inactive
    end

    subject { FellowOpportunity.most_neglected }
    
    it "contains the neglected opp first" do
      expect(subject.first).to eq(neglected)
    end
    
    it "contains the recently updated opp last" do
      expect(subject.last).to eq(recent)
    end
    
    it "does not contain the inactive opp" do
      expect(subject).to_not include(inactive)
    end
  end
  
  ##################
  # Instance methods
  ##################

  describe '#stage accessors' do
    let(:name_first) { 'first' }
    let(:name_second) { 'second' }
    let(:name_third) { 'third' }
    
    let(:stage_first) { create :opportunity_stage, name: name_first, position: 0, active_status: true }
    let(:stage_second) { create :opportunity_stage, name: name_second, position: 1, active_status: true }
    let(:stage_third) { create :opportunity_stage, name: name_third, position: 2, active_status: false }

    let(:fellow_opportunity) { create :fellow_opportunity, opportunity_stage: stage_first }
    
    before do
      fellow_opportunity; stage_second; stage_third
      fellow_opportunity.update opportunity_stage_id: stage_first.id
    end
    
    def expect_stage opp_stage
      expect(fellow_opportunity.opportunity_stage).to eq(opp_stage)
    end
    
    def expect_log stage_name
      expect(fellow_opportunity.logs.last.status).to eq(stage_name)
    end

    describe '#stage' do
      it "returns the name of the opportunity stage" do
        expect_stage(stage_first)
      end
    end

    describe '#update_stage(stage_name, options={})' do
      let(:name_update) { name_second }
      let(:options) { {} }
      
      before do
        fellow_opportunity.update_stage(name_update, options)
        fellow_opportunity.reload
      end
      
      it "sets the opportunity_stage based on name" do
        expect_stage(stage_second)
      end
    
      it "creates a log record when stage is set" do
        expect_log(name_second)
      end
      
      it "updates last_contact_at timestamp" do
        expect(fellow_opportunity.last_contact_at).to be_within(0.1).of(Time.now)
      end
    
      describe 'with special status "no change"' do
        let(:name_update) { 'no change' }
        
        it "stays as current stage" do
          expect_stage(stage_first)
        end
        
        it "creates a log record of same record" do
          expect_log(name_first)
        end
      end
    
      describe 'with special status "no change", and "from" option' do
        let(:options) { {from: name_third} }
        let(:name_update) { 'no change' }
        
        it "sets to 'from' stage" do
          expect_stage(stage_third)
        end
        
        it "creates a log record of 'from' record" do
          expect_log(name_third)
        end
      end
    
      describe 'with special status "next"' do
        let(:name_update) { 'next' }
        
        it "moves to next stage" do
          expect_stage(stage_second)
        end
        
        it "creates a log record of changed stage" do
          expect_log(name_second)
        end
      end
      
      describe 'with special status "next", and "from" option' do
        let(:options) { {from: name_second} }
        let(:name_update) { 'next' }
        
        it "moves to the next stage after 'from' stage" do
          expect_stage(stage_third)
        end
        
        it "creates a log record of changed stage" do
          expect_log(name_third)
        end
      end
    
      describe 'with special status "skip"' do
        let(:name_update) { 'skip' }
        
        it "moves to next stage" do
          expect_stage(stage_second)
        end
        
        it "creates a log record of skipped stage" do
          expect_log("skipped to: #{name_second}")
        end
      end
    
      describe 'with special status "skip", and "from" option' do
        let(:options) { {from: name_second} }
        let(:name_update) { 'skip' }
        
        it "moves to next stage" do
          expect_stage(stage_third)
        end
        
        it "creates a log record of skipped stage" do
          expect_log("skipped to: #{name_third}")
        end
      end
      
      describe 'when new opp stage has a different active status' do
        let(:name_update) { name_third }
        
        it "updates the fellow_status active flag to match" do
          expect(fellow_opportunity.reload.active).to eq(stage_third.active_status)
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
