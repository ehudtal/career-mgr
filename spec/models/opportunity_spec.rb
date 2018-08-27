require 'rails_helper'
require 'support/taggable_helpers'

RSpec.describe Opportunity, type: :model do
  let(:employer) { build :employer }
  
  ##############
  # Associations
  ##############

  it { should belong_to :employer }
  it { should belong_to :opportunity_type }
  
  it { should have_many :tasks }
  it { should have_many :fellow_opportunities }
  it { should have_many :fellows }
  
  it { should have_and_belong_to_many :industries }
  it { should have_and_belong_to_many :interests }
  it { should have_and_belong_to_many :majors }
  it { should have_and_belong_to_many :metros }
  it { should have_and_belong_to_many :locations }
  
  it_behaves_like 'taggable', :opportunity, :industry
  it_behaves_like 'taggable', :opportunity, :interest
  it_behaves_like 'taggable', :opportunity, :metro
  
  it_behaves_like 'taggable_combined', :opportunity, :industry, :interest
  
  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  it_should_behave_like "valid url", :job_posting_url
  
  describe 'validating locate-ability' do
    let(:location_error) { "must contain a zip code or a metro area" }
    
    it "allows opportunity with just a location zip code, no metro area" do
      contact = build :contact
      location = Location.new contact: contact

      opportunity = Opportunity.new
      allow(opportunity).to receive(:locations).and_return([location])
      
      opportunity.valid?
      expect(opportunity.errors[:location]).to_not include(location_error)
    end
    
    it "allows opportunity with just a metro area, no location zip code" do
      opportunity = Opportunity.new
      allow(opportunity).to receive(:metros).and_return([:placeholder])
      
      opportunity.valid?
      expect(opportunity.errors[:location]).to_not include(location_error)
    end
    
    it "is invalid if location zip cod and metro area are missing" do
      opportunity = Opportunity.new
      
      opportunity.valid?
      expect(opportunity.errors[:location]).to include(location_error)
    end
  end
  
  ###############
  # Serialization
  ###############

  it "serializes steps to an array" do
    expect(Opportunity.new.steps).to be_an(Array)
  end
  
  ##################
  # Instance methods
  ##################

  describe '#candidates' do
    let(:opportunity) { create :opportunity }
    let(:fellow) { create :fellow }
    let(:interest) { create :interest }
    let(:industry) { create :industry }
    let(:major_parent) { create :major }
    let(:major_child) { create :major, parent: major_parent }
    let(:metro) { create :metro }
    
    def matching_industry
      opportunity.industries << industry
      fellow.industries << industry
    end
      
    def matching_interest
      opportunity.interests << interest
      fellow.interests << interest
    end
     
    def matching_metro
      opportunity.metros << metro
      fellow.metros << metro
    end
    
    def matching_majors
      opportunity.majors << major_child
      fellow.majors << major_child
    end
    
    describe 'with matching metro' do
      before { matching_metro }
    
      it "includes fellow when there is a shared interest" do
        matching_interest
        expect(opportunity.candidates).to include(fellow)
      end
    
      it "excludes fellow when fellow does not share the interest" do
        opportunity.interests << interest
        expect(opportunity.candidates).to_not include(fellow)
      end
    
      it "excludes fellow when opp does not share the interest" do
        fellow.interests << interest
        expect(opportunity.candidates).to_not include(fellow)
      end

      it "includes fellow when there is a shared industry" do
        matching_industry
        expect(opportunity.candidates).to include(fellow)
      end
    
      it "excludes fellow when fellow does not share the industry" do
        opportunity.industries << industry
        expect(opportunity.candidates).to_not include(fellow)
      end
    
      it "excludes fellow when opp does not share the industry" do
        fellow.industries << industry
        expect(opportunity.candidates).to_not include(fellow)
      end

      it "includes fellow when there is a shared major" do
        matching_majors
        expect(opportunity.candidates).to include(fellow)
      end

      it "includes fellow when opp major category matches specific fellow major" do
        opportunity.majors << major_parent
        fellow.majors << major_child
        
        expect(opportunity.candidates).to include(fellow)
      end

      it "includes fellow when specific opp major matches fellow major category" do
        opportunity.majors << major_child
        fellow.majors << major_parent

        expect(opportunity.candidates).to include(fellow)
      end
    
      it "excludes fellow when fellow does not share the major" do
        opportunity.majors << major_parent
        expect(opportunity.candidates).to_not include(fellow)
      end
    
      it "excludes fellow when opp does not share the major" do
        fellow.majors << major_parent
        expect(opportunity.candidates).to_not include(fellow)
      end
    end
    
    describe 'without matching metro' do
      it "excludes even with shared industry" do
        matching_industry
        expect(opportunity.candidates).to_not include(fellow)
      end

      it "excludes even with shared interest" do
        matching_interest
        expect(opportunity.candidates).to_not include(fellow)
      end

      it "excludes even with shared major" do
        matching_majors
        expect(opportunity.candidates).to_not include(fellow)
      end
    end
    
    it "removes duplicates" do
      matching_metro
      matching_industry
      matching_interest
      matching_majors
      
      expect(opportunity.candidates).to include(fellow)
      expect(opportunity.candidates.size).to eq(1)
    end
  end
  
  describe '#formatted_name' do
    let(:employer) { build :employer, name: 'ABC Employer' }
    let(:opportunity) { build :opportunity, name: 'Internship', employer: employer } 
    
    it "combines employer and opportunity name" do
      expect(opportunity.formatted_name).to eq("ABC Employer - Internship")
    end
  end
  
  describe "#state_ids_for_metro_ids" do
    it "returns associated metro ids by state" do
      opportunity = build :opportunity
      
      lincoln = create :metro, code: '1001', name: 'Lincoln, NE', state: 'NE', source: 'MSA'
      nebraska = create :metro, code: 'NE', source: 'ST'
      fellow_ne = create :fellow
      fellow_ne.metros << nebraska
    
      aimes = create :metro, code: '1002', name: 'Aimes, IA', state: 'IA', source: 'MSA'
      iowa = create :metro, code: 'IA', source: 'ST'
      fellow_ia = create :fellow
      fellow_ia.metros << iowa

      lenexa = create :metro, code: '1003', name: 'Lenexa, KS', state: 'KS', source: 'MSA'
      kansas = create :metro, code: 'KS', source: 'ST'
      fellow_ks = create :fellow
      fellow_ks.metros << kansas
    
      state_ids = opportunity.state_ids_for_metro_ids([lincoln.id, aimes.id])
    
      expect(state_ids).to be_an(Array)
      expect(state_ids.size).to eq(2)
      expect(state_ids).to include(nebraska.id)
      expect(state_ids).to include(iowa.id)
      expect(state_ids).to_not include(kansas.id)
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
