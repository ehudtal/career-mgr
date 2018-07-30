require'digest/md5'
require 'rails_helper'
require 'support/taggable_helpers'

RSpec.describe Fellow, type: :model do
  let(:email) { 'email@example.com' }
  let(:fellow) { create :fellow, contact_attributes: {email: email} }
  let(:unemployed_status) { create :employment_status_unemployed }
  
  def create_site label
    site = create :"site_#{label}"

    metro = create :metro, name: "#{label.upcase} Metro Area"
    postal_code = create :postal_code, msa_code: metro.code
    
    location = create(:location, locateable: site)
    location.contact = create(:contact, postal_code: postal_code.code)
    
    site
  end
  
  let(:site_sjsu) { create_site :sjsu }
  let(:site_run) { create_site :run }
  let(:site_nlu) { create_site :nlu }

  let(:sites) { [site_sjsu, site_run, site_nlu] }
  
  let(:metro_sjsu) { Metro.find_by name: 'SJSU Metro Area' }
  
  ##############
  # Associations
  ##############
  
  it { should have_one :contact }
  it { should have_one :access_token }
  
  it { should have_many :cohort_fellows }
  it { should have_many :cohorts }
  it { should have_many :fellow_opportunities }
  
  it { should have_and_belong_to_many :interests }
  it { should have_and_belong_to_many :industries }
  it { should have_and_belong_to_many :metros }
  
  it { should belong_to :employment_status }
  it { should belong_to :user }
  
  it_behaves_like 'taggable', :fellow, :industry
  it_behaves_like 'taggable', :fellow, :interest
  it_behaves_like 'taggable', :fellow, :metro
  
  it_behaves_like 'taggable_combined', :fellow, :industry, :interest
  
  #############
  # Validations
  #############

  def self.required_attributes
    [:first_name, :last_name]
  end
  
  required_attributes.each do |attribute|
    it { should validate_presence_of(attribute) }
  end
  
  it { should validate_inclusion_of(:graduation_semester).in_array(Course::VALID_SEMESTERS) }
  
  it { should validate_numericality_of(:graduation_year).is_greater_than(2010) }
  it { should validate_numericality_of(:graduation_year).is_less_than(2050) }
  it { should validate_numericality_of(:graduation_year).only_integer }
  it { should validate_numericality_of(:graduation_year).allow_nil }
  
  it { should validate_numericality_of(:graduation_fiscal_year).is_greater_than(2010) }
  it { should validate_numericality_of(:graduation_fiscal_year).is_less_than(2050) }
  it { should validate_numericality_of(:graduation_fiscal_year).only_integer }
  it { should validate_numericality_of(:graduation_fiscal_year).allow_nil }
  
  it { should validate_numericality_of(:gpa).is_greater_than_or_equal_to(0.0) }
  it { should validate_numericality_of(:gpa).is_less_than_or_equal_to(4.0) }
  it { should validate_numericality_of(:gpa).allow_nil }
  
  it { should validate_numericality_of(:efficacy_score).is_greater_than_or_equal_to(0.0) }
  it { should validate_numericality_of(:efficacy_score).is_less_than_or_equal_to(1.0) }
  it { should validate_numericality_of(:efficacy_score).allow_nil }
  
  ###########
  # Callbacks
  ###########

  describe 'fellow/user matching attempt' do
    it "executes upon create" do
      new_fellow = build :fellow, contact_attributes: {email: email}
      
      expect(FellowUserMatcher).to receive(:match).with(email).once

      new_fellow.save
    end

    it "executes upon save, if no user already associated" do
      fellow
      expect(FellowUserMatcher).to receive(:match).with(email).once

      fellow.save
    end

    it 'does not execute when user is already associated' do
      user = create :user
      fellow = create :fellow, user_id: user.id, contact_attributes: {email: email}

      expect(FellowUserMatcher).to receive(:match).with(email).never

      fellow.save
    end
  end
  
  ###############
  # Normalization
  ###############

  describe 'student key' do
    it "auto-generates upon save" do
      fellow = create :fellow, first_name: 'Bob', last_name: 'Smith', graduation_year: '2018'
      hash = Digest::MD5.hexdigest([fellow.first_name, fellow.last_name, fellow.graduation_year, 0].join('-'))[0,4]
      
      expect(fellow.key).to eq("BS18#{hash}".upcase)
    end
    
    it "ensures the key is always unique" do
      previous_fellow = create :fellow, first_name: 'Bob', last_name: 'Smith', graduation_year: '2018'
      fellow = create :fellow, first_name: 'Bob', last_name: 'Smith', graduation_year: '2018'

      hash = Digest::MD5.hexdigest([fellow.first_name, fellow.last_name, fellow.graduation_year, 1].join('-'))[0,4]
      
      expect(fellow.key).to eq("BS18#{hash}".upcase)
    end
    
    it "doesn't generate a key if one already exists" do
      fellow = create :fellow, first_name: 'Bob', last_name: 'Smith', graduation_year: '2018', key: 'turtles'
      expect(fellow.key).to eq('turtles')
    end
  end
  
  ###############
  # Class methods
  ###############

  describe '::import(io)' do
    before { sites; unemployed_status }
    
    def import label
      Fellow.import(File.read("#{Rails.root}/spec/fixtures/#{label}.csv"))
    end
    
    describe 'when elements don\'t yet exist' do
      before { import :paf_master_roster }

      describe "creating the fellow" do
        let(:cohort) { Cohort.last }
        let(:course) { Course.last }
        let(:fellow) { Fellow.last }
        let(:contact) { fellow.contact }
        let(:cohort_fellow) { CohortFellow.last }
      
        it "sets everything correctly" do
          expect(cohort.name).to eq("San Jose State University, Spring 2016")
          expect(cohort.course).to eq(Course.last)
          
          expect(course.semester).to eq('Spring')
          expect(course.year).to eq(2016)

          expect(fellow.first_name).to eq('Antoinette')
          expect(fellow.last_name).to eq('Martin')
          expect(fellow.graduation_year).to eq(2019)
          expect(fellow.graduation_semester).to eq('Spring')
          expect(fellow.graduation_fiscal_year).to eq(2019)
          expect(fellow.interests_description).to eq('Project Manager')
          expect(fellow.major).to eq('Undeclared')
          expect(fellow.affiliations).to eq('***Did not list***')
          expect(fellow.gpa).to be_within(0.01).of(2.95)
          expect(fellow.linkedin_url).to eq('https://www.linkedin.com/in/antoinette-marie-martin-bb993a108')
          expect(fellow.staff_notes).to eq('Shows promise')
          expect(fellow.metros).to include(metro_sjsu)

          expect(contact.email).to eq('antoinette.martin@sjsu.edu')
          expect(contact.phone).to eq('8315399699')
          expect(contact.postal_code).to eq(site_sjsu.location.contact.postal_code)

          expect(cohort_fellow.grade).to be_within(0.01).of(0.83)
          expect(cohort_fellow.attendance).to be_within(0.01).of(0.82)
          expect(cohort_fellow.nps_response).to eq(10)
          expect(cohort_fellow.feedback).to eq("needs improvement")
          expect(cohort_fellow.endorsement).to eq(4)
          expect(cohort_fellow.professionalism).to eq(4)
          expect(cohort_fellow.teamwork).to eq(3)
        end
      end
    end
    
    describe 'when elements already exist' do
      before do
        import :paf_master_roster
        import :paf_master_roster_update
      end
    
      describe "updating the fellow" do
        let(:fellow) { Fellow.last }
        let(:contact) { fellow.contact }
        let(:cohort_fellow) { CohortFellow.last }

        it "updates the fellow attributes" do
          expect(fellow.graduation_year).to eq(2020)
          expect(fellow.graduation_semester).to eq('Fall')
          expect(fellow.graduation_fiscal_year).to eq(2020)
          expect(fellow.interests_description).to eq('Product Manager')
          expect(fellow.major).to eq('Computer Science')
          expect(fellow.affiliations).to eq('Professional Amateurs')
          expect(fellow.gpa).to be_within(0.01).of(3.85)
          expect(fellow.linkedin_url).to eq('https://www.linkedin.com/in/tester')
          expect(fellow.staff_notes).to eq('Shows promises')

          expect(contact.email).to eq('antoinette.martin2@sjsu.edu')
          expect(contact.phone).to eq('8315399690')

          expect(cohort_fellow.grade).to be_within(0.01).of(0.73)
          expect(cohort_fellow.attendance).to be_within(0.01).of(0.72)
          expect(cohort_fellow.nps_response).to eq(8)
          expect(cohort_fellow.feedback).to eq("needs improvements")
          expect(cohort_fellow.endorsement).to eq(3)
          expect(cohort_fellow.professionalism).to eq(3)
          expect(cohort_fellow.teamwork).to eq(2)
        end
      end
    end
  end
  
  ##################
  # Instance methods
  ##################
  
  describe "#cohort" do
    def add_cohort
      create(:cohort_fellow, fellow: fellow).cohort
    end
    
    it "should be the most recent cohort" do
      first_cohort = add_cohort
      second_cohort = add_cohort
      
      expect(fellow.cohort).to eq(second_cohort)
    end
  end
  
  describe '#distance_from' do
    it "calculates the distance between the fellow's zip and the given zip" do
      fellow = build :fellow, contact: build(:contact, postal_code: '10001')
      other_zip = '10002'
      
      allow(PostalCode).to receive(:distance).with('10001', '10002').and_return(21)
      expect(fellow.distance_from(other_zip)).to eq(21)
    end
    
    it "memoizes the result" do
      fellow = build :fellow, contact: build(:contact, postal_code: '10001')
      other_zip = '10002'
      
      allow(PostalCode).to receive(:distance).with('10001', '10002').and_return(21).once
      fellow.distance_from(other_zip)
    end
  end
  
  describe '#nearest_distance' do
    it "finds the closest of multiple zip codes" do
      fellow = build :fellow, contact: build(:contact, postal_code: '10001')
      near_zip = '10002'
      far_zip = '90001'
      
      allow(fellow).to receive(:distance_from).with(near_zip).and_return(5)
      allow(fellow).to receive(:distance_from).with(far_zip).and_return(15)
      
      expect(fellow.nearest_distance([near_zip, far_zip])).to eq(5)
    end
  end
  
  describe '#full_name' do
    it "combines first and last name" do
      fellow = Fellow.new first_name: 'Bob', last_name: 'Smith'
      expect(fellow.full_name).to eq('Bob Smith')
    end
    
    it "uses only first name if last is missing" do
      fellow = Fellow.new first_name: 'Bob'
      expect(fellow.full_name).to eq('Bob')
    end
    
    it "uses only last name if first is missing" do
      fellow = Fellow.new last_name: 'Smith'
      expect(fellow.full_name).to eq('Smith')
    end
  end
  
  describe '#graduation' do
    it "combines semester and year" do
      fellow = Fellow.new graduation_semester: 'Fall', graduation_year: 2018
      expect(fellow.graduation).to eq('Fall 2018')
    end

    it "uses only semester if year is missing" do
      fellow = Fellow.new graduation_semester: 'Fall'
      expect(fellow.graduation).to eq('Fall')
    end

    it "uses only year if semester is missing" do
      fellow = Fellow.new graduation_year: 2018
      expect(fellow.graduation).to eq('2018')
    end
  end
  
  describe '#default_metro' do
    let(:metro) { create :metro, code: 'LNK' }
    let(:postal_code) { create :postal_code, msa_code: metro.code }
    let(:contact) { create :contact, postal_code: postal_code.code }
    let(:fellow) { create :fellow }
    
    before { metro; postal_code; fellow }
    
    it "picks the metro based on fellow's postal code" do
      fellow.contact = contact
      expect(fellow.default_metro).to eq(metro)
    end
    
    it "returns nil if fellow's postal code doesn't have a metro match" do
      fellow.contact = create(:contact)
      expect(fellow.default_metro).to be_nil
    end
    
    it "memoizes the result when metro found" do
      fellow.contact = contact
      
      expect(PostalCode).to receive(:find_by).with(code: fellow.contact.postal_code).once.and_return(postal_code)
      2.times { fellow.default_metro }
    end

    it "memoizes the result when metro not found" do
      fellow.contact = create :contact
      
      expect(PostalCode).to receive(:find_by).with(code: fellow.contact.postal_code).once.and_return(postal_code)
      2.times { fellow.default_metro }
    end
  end
end
