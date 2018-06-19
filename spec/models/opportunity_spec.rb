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
  it { should have_and_belong_to_many :metros }
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
    let(:metro) { create :metro }
    
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
    
    it "includes fellow when there is a shared metro" do
      opportunity.metros << metro
      fellow.metros << metro
      
      expect(opportunity.candidates).to include(fellow)
    end
    
    it "excludes fellow when fellow does not share the interest" do
      opportunity.metros << metro
      fellow
      
      expect(opportunity.candidates).to_not include(fellow)
    end
    
    it "excludes fellow when opp does not share the interest" do
      opportunity
      fellow.metros << metro
      
      expect(opportunity.candidates).to_not include(fellow)
    end
    
    it "removes duplicates" do
      opportunity.interests << interest
      opportunity.industries << industry
      opportunity.metros << metro

      fellow.interests << interest
      fellow.industries << industry
      fellow.metros << metro
      
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
  
  describe '#industry_tags' do
    it "returns a semicolon-delimited list of associated industry names" do
      opportunity = build :opportunity
      industry_1 = build :industry, name: 'Industry 1'
      industry_2 = build :industry, name: 'Industry 2'
      
      allow(opportunity).to receive(:industries).and_return([industry_1, industry_2])
      
      expect(opportunity.industry_tags).to eq("Industry 1;Industry 2")
    end
  end

  describe '#industry_tags=' do
    it "converts a semicolon-delimited list of industry names into associations" do
      opportunity = create :opportunity
      industry_1 =  create :industry, name: 'Industry 1'
      industry_2 =  create :industry, name: 'Industry 2'
      industry_3 =  create :industry, name: 'Industry 3'
      
      opportunity.industry_tags = "Industry 1;Industry 2"
      
      expect(opportunity.industries).to include(industry_1)
      expect(opportunity.industries).to include(industry_2)
      expect(opportunity.industries).to_not include(industry_3)
    end
  end
  
  describe '#interest_tags' do
    it "returns a semicolon-delimited list of associated interest names" do
      opportunity = build :opportunity
      interest_1 = build :interest, name: 'Interest 1'
      interest_2 = build :interest, name: 'Interest 2'
      
      allow(opportunity).to receive(:interests).and_return([interest_1, interest_2])
      
      expect(opportunity.interest_tags).to eq("Interest 1;Interest 2")
    end
  end

  describe '#interest_tags=' do
    it "converts a semicolon-delimited list of interest names into associations" do
      opportunity = create :opportunity
      interest_1 =  create :interest, name: 'Interest 1'
      interest_2 =  create :interest, name: 'Interest 2'
      interest_3 =  create :interest, name: 'Interest 3'
      
      opportunity.interest_tags = "Interest 1;Interest 2"
      
      expect(opportunity.interests).to include(interest_1)
      expect(opportunity.interests).to include(interest_2)
      expect(opportunity.interests).to_not include(interest_3)
    end
  end
  
  describe '#metro_tags' do
    it "returns a semicolon-delimited list of associated metro names" do
      opportunity = build :opportunity
      metro_1 = build :metro, name: 'Metro 1'
      metro_2 = build :metro, name: 'Metro 2'
      
      allow(opportunity).to receive(:metros).and_return([metro_1, metro_2])
      
      expect(opportunity.metro_tags).to eq("Metro 1;Metro 2")
    end
  end

  describe '#metro_tags=' do
    it "converts a semicolon-delimited list of metro names into associations" do
      opportunity = create :opportunity
      metro_1 =  create :metro, name: 'Metro 1'
      metro_2 =  create :metro, name: 'Metro 2'
      metro_3 =  create :metro, name: 'Metro 3'
      
      opportunity.metro_tags = "Metro 1;Metro 2"
      
      expect(opportunity.metros).to include(metro_1)
      expect(opportunity.metros).to include(metro_2)
      expect(opportunity.metros).to_not include(metro_3)
    end
  end
  
  describe '#postal codes' do
    it "returns the postal codes of all locations" do
      opportunity = build :opportunity
      location1 = opportunity.locations << build(:location, contact: build(:contact, postal_code: '10001'))
      location2 = opportunity.locations << build(:location, contact: build(:contact, postal_code: '10002'))
      
      expect(opportunity.postal_codes.size).to eq(2)
      expect(opportunity.postal_codes).to include('10001')
      expect(opportunity.postal_codes).to include('10002')
    end
  end
end
