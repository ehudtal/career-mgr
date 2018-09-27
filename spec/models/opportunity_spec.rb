require 'rails_helper'
require 'support/taggable_helpers'

RSpec.describe Opportunity, type: :model do
  let(:employer) { build :employer }
  
  ##############
  # Associations
  ##############

  it { should belong_to :employer }
  it { should belong_to :opportunity_type }
  it { should belong_to :region }
  
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
  
  ###########
  # Callbacks
  ###########

  it "sets the priority before save" do
    opportunity = build :opportunity
    allow(opportunity).to receive(:calculated_priority).and_return(42)
    expect(opportunity.priority).to eq(Opportunity.column_defaults['priority'])
    
    opportunity.save
    expect(opportunity.priority).to eq(42)
  end
  
  ########
  # Scopes
  ########

  describe 'prioritized' do
    let(:partner) { create :employer, employer_partner: true }
    let(:nonpartner) { create :employer, employer_partner: false }
    
    let(:first)  { create :opportunity, published: false, employer: partner,    inbound: true,  recurring: true }
    let(:second) { create :opportunity, published: false, employer: nonpartner, inbound: false, recurring: false }
    let(:third)  { create :opportunity, published: true,  employer: partner,    inbound: true,  recurring: true }
    let(:fourth) { create :opportunity, published: true,  employer: nonpartner, inbound: false, recurring: false }
    
    before { second; fourth; first; third }
    
    subject { Opportunity.prioritized }
    
    it { expect(subject[0]).to eq(first) }
    it { expect(subject[1]).to eq(second) }
    it { expect(subject[2]).to eq(third) }
    it { expect(subject[3]).to eq(fourth) }
  end
  
  ###############
  # Serialization
  ###############

  it "serializes steps to an array" do
    expect(Opportunity.new.steps).to be_an(Array)
  end
  
  ###############
  # Class methods
  ###############
  
  describe '#csv_headers' do
    subject { Opportunity.csv_headers }
    it { should eq(['Region', 'Employer', 'Position', 'Type', 'Location', 'Link', 'Employer Partner', 'Inbound', 'Recurring', 'Interests'])}
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
    let(:opportunity_type) { create :opportunity_type }
    
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
    
    def unsubscribed
      fellow.update receive_opportunities: false
    end
    
    before do
      opportunity.opportunity_type = opportunity_type
      fellow.opportunity_types << opportunity_type
    end
    
    describe 'with matching metro' do
      before { matching_metro }
    
      it "includes fellow when there is a shared interest" do
        matching_interest
        expect(opportunity.candidates).to include(fellow)
      end
    
      it "excludes fellow when fellow does not share overlap opportunity types" do
        matching_interest
        fellow.opportunity_types = []
        
        expect(opportunity.candidates).to_not include(fellow)
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
      
      it "excludes fellow when unsubscribed from receiving opportunities" do
        matching_industry
        unsubscribed
        
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
  
  describe '#csv_fields' do
    let(:employer) { create :employer, employer_partner: true}
    let(:opportunity) { create :opportunity, employer: employer, inbound: false, recurring: true, job_posting_url: 'http://example.com', name: 'CSV Opp' }

    let(:fellow) { create :fellow }
    let(:interest) { create :interest, name: 'Interest' }
    let(:industry) { create :industry, name: 'Industry' }
    let(:major) { create :major, name: 'Major' }
    
    let(:contact) { create :contact, city: 'Lincoln', contactable: location }
    let(:location) { create :location, locateable: opportunity }
    
    before do
      contact
      
      opportunity.interests << interest
      opportunity.industries << industry
      opportunity.majors << major
      opportunity.locations << location
      opportunity.metros.first.update(name: 'Omaha, NE-IA')
    end
    
    subject { opportunity.csv_fields }
    
    it { should be_an(Array) }
    it { expect(subject[0]).to eq(opportunity.region.name) }
    it { expect(subject[1]).to eq(opportunity.employer.name) }
    it { expect(subject[2]).to eq(opportunity.name) }
    it { expect(subject[3]).to eq(opportunity.opportunity_type.name) }
    it { expect(subject[4]).to eq('Omaha, NE') }
    it { expect(subject[5]).to eq(opportunity.job_posting_url) }
    it { expect(subject[6]).to eq('yes') }
    it { expect(subject[7]).to eq('no') }
    it { expect(subject[8]).to eq('yes') }
    it { expect(subject[9]).to eq("Industry, Interest, Major") }
  end
  
  describe '#priority' do
    let(:employer) { create :employer, employer_partner: employer_partner }
    let(:opportunity) { build :opportunity, employer: employer, inbound: inbound, recurring: recurring, published: published }

    let(:employer_partner) { false }
    let(:inbound) { false }
    let(:recurring) { false }
    
    subject { opportunity.calculated_priority }
    
    describe 'when previously published' do
      let(:published) { true }
      
      describe 'when employer_partner AND inbound AND recurring' do
        let(:employer_partner) { true }
        let(:inbound) { true }
        let(:recurring) { true }
      
        it { should eq(10) }
      end
    
      describe 'when employer_partner AND inbound' do
        let(:employer_partner) { true }
        let(:inbound) { true }

        it { should eq(11) }
      end
    
      describe 'when inbound' do
        let(:inbound) { true }
        it { should eq(12) }
      end
    
      describe 'when employer_partner AND recurring' do
        let(:employer_partner) { true }
        let(:recurring) { true }
      
        it { should eq(13) }
      end
    
      describe 'when employer_partner' do
        let(:employer_partner) { true }
      
        it { should eq(14) }
      end
    
      describe 'when recurring' do
        let(:recurring) { true }
        it { should eq(15) }
      end
    
      describe 'when none are true' do
        it { should eq(16) }
      end
    end
    
    describe 'when not previously published' do
      let(:published) { false }
      
      describe 'when employer_partner AND inbound AND recurring' do
        let(:employer_partner) { true }
        let(:inbound) { true }
        let(:recurring) { true }
      
        it { should eq(0) }
      end
    
      describe 'when employer_partner AND inbound' do
        let(:employer_partner) { true }
        let(:inbound) { true }

        it { should eq(1) }
      end
    
      describe 'when inbound' do
        let(:inbound) { true }
        it { should eq(2) }
      end
    
      describe 'when employer_partner AND recurring' do
        let(:employer_partner) { true }
        let(:recurring) { true }
      
        it { should eq(3) }
      end
    
      describe 'when employer_partner' do
        let(:employer_partner) { true }
      
        it { should eq(4) }
      end
    
      describe 'when recurring' do
        let(:recurring) { true }
        it { should eq(5) }
      end
    
      describe 'when none are true' do
        it { should eq(6) }
      end
    end
  end
  
  describe '#unpublish!' do
    subject { opportunity.unpublish!; opportunity.reload.published }
    
    describe 'when opp is already published' do
      let(:opportunity) { create :opportunity, published: true }
      it { should eq(false) }
    end

    describe 'when opp is unpublished' do
      let(:opportunity) { create :opportunity, published: false }
      it { should eq(false) }
    end
  end
  
  describe '#set_default_industries' do
    let(:industry_included) { create :industry } 
    let(:industry_excluded) { create :industry } 
    let(:employer) { create :employer }
    
    before { employer.industry_ids << industry_included.id }
    
    subject { o = Opportunity.new employer: chosen_employer; o.set_default_industries; o.industry_ids }
    
    describe 'when employer has industries' do
      let(:chosen_employer) { employer }
      
      it { should include(industry_included.id) }
      it { should_not include(industry_excluded.id) }
    end
    
    describe 'when employer has no industries' do
      let(:chosen_employer) { create :employer }
      
      it { should_not include(industry_included.id) }
      it { should_not include(industry_excluded.id) }
    end
  end
end
