require 'rails_helper'

RSpec.describe Site, type: :model do
  
  ##############
  # Associations
  ##############
  
  it { should have_many :courses }
  
  it { should have_one :location }

  #############
  # Validations
  #############

  it { should validate_presence_of(:code) }
  it { should validate_presence_of(:name) }
  
  describe "validating uniqueness" do
    subject { create :site }

    it { should validate_uniqueness_of(:code) }
    it { should validate_uniqueness_of(:name) }
  end
  
  ###############
  # Class methods
  ###############

  describe '::cohort_for(code)' do
    let(:code) { 'SJSUS18' }
    let(:site) { create :site, code: 'SJSU', name: 'San Jose State University' }
    let(:course) { create :course, semester: 'Spring', year: 2018, site_id: site.id }
    let(:cohort) { create :cohort, course_id: course.id }
    
    before { site }
    
    it "finds an existing cohort" do
      course; cohort
      
      expect(Site.cohort_for(code)).to eq(cohort)
    end
    
    it "creates cohort when missing" do
      course
      
      cohort = Site.cohort_for(code)
      expect(cohort.course).to eq(course)
      expect(cohort.name).to eq("San Jose State University, Spring 2018")
    end
    
    it "creates course AND cohort when missing" do
      cohort = Site.cohort_for(code)
      course = cohort.course
      
      expect(cohort.name).to eq("San Jose State University, Spring 2018")
      
      expect(course.site).to eq(site)
      expect(course.semester).to eq('Spring')
      expect(course.year).to eq(2018)
    end
    
    it "returns nil if code doesn't match expected pattern" do
      expect(Site.cohort_for('fdsfdsfdsaf')).to be_nil
    end
  end
  
  ##################
  # Instance methods
  ##################
  
  describe 'metro' do
    let(:metro) { create :metro }
    let(:state) { create :metro, code: 'NE' }
    let(:postal_code) { create :postal_code, code: '10001', msa_code: metro.code }
    let(:location) { create :location, locateable: site }
    let(:contact) { create :contact, postal_code: postal_code.code, contactable: location, state: 'NE' }
    let(:site) { build :site }
    
    before { contact; state }
    
    it "assigns the metro based on site's zip code, when available" do
      expect(site.metro).to eq(metro)
    end
    
    it "assigns the state metro when site's zip doesn't map to a metro area" do
      postal_code.update msa_code: 'nothing'
      expect(site.metro).to eq(state)
    end
  end
end
