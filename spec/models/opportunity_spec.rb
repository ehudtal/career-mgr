require 'rails_helper'

RSpec.describe Opportunity, type: :model do
  let(:employer) { build :employer }
  
  ##############
  # Associations
  ##############

  it { should belong_to :employer }
  
  it { should have_many :tasks }
  it { should have_many :fellow_opportunities }
  it { should have_many :fellows }
  
  it { should have_and_belong_to_many :industries }
  it { should have_and_belong_to_many :interests }
  it { should have_and_belong_to_many :locations }
  
  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  it_should_behave_like "valid url", :job_posting_url
  
  ##################
  # Instance methods
  ##################

  describe '#candidates' do
    let(:opportunity) { create :opportunity }
    let(:fellow) { create :fellow }
    let(:interest) { create :interest }
    let(:industry) { create :industry }
    
    it "includes fellow when there is a shared interest" do
      opportunity.interests << interest
      fellow.interests << interest
      
      expect(opportunity.candidates).to include(fellow)
    end
    
    it "excludes fellow when fellow does not share the interest" do
      opportunity.interests << interest
      fellow
      
      expect(opportunity.candidates).to_not include(fellow)
    end
    
    it "excludes fellow when opp does not share the interest" do
      opportunity
      fellow.interests << interest
      
      expect(opportunity.candidates).to_not include(fellow)
    end

    it "includes fellow when there is a shared industry" do
      opportunity.industries << industry
      fellow.industries << industry
      
      expect(opportunity.candidates).to include(fellow)
    end
    
    it "excludes fellow when fellow does not share the industry" do
      opportunity.industries << industry
      fellow
      
      expect(opportunity.candidates).to_not include(fellow)
    end
    
    it "excludes fellow when opp does not share the industry" do
      opportunity
      fellow.industries << industry
      
      expect(opportunity.candidates).to_not include(fellow)
    end
    
    it "removes duplicates" do
      opportunity.interests << interest
      opportunity.industries << industry

      fellow.interests << interest
      fellow.industries << industry
      
      expect(opportunity.candidates).to include(fellow)
      expect(opportunity.candidates.size).to eq(1)
    end
  end
  
  describe '#candidate_ids=' do
    it "creates fellow_opportunities" do
      fellow = create :fellow
      opportunity = create :opportunity
      
      initial_stage = create :opportunity_stage, position: 0
      next_stage =    create :opportunity_stage, position: 1
      
      opportunity.candidate_ids = [fellow.id]

      expect(opportunity.fellow_opportunities.count).to eq(1)
      expect(opportunity.fellow_opportunities.first.opportunity_stage).to eq(initial_stage)
      expect(opportunity.fellows.first).to eq(fellow)
    end
  end
end
