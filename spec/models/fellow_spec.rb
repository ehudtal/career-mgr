require'digest/md5'
require 'rails_helper'

RSpec.describe Fellow, type: :model do
  let(:fellow) { create :fellow }
  
  ##############
  # Associations
  ##############
  
  it { should have_one :contact }
  
  it { should have_many :cohort_fellows }
  it { should have_many :cohorts }
  
  it { should have_and_belong_to_many :interests }
  it { should have_and_belong_to_many :industries }
  it { should have_and_belong_to_many :metros }
  
  it { should belong_to :employment_status }
  
  #############
  # Validations
  #############

  def self.required_attributes
    [:first_name, :last_name, :employment_status_id]
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
  
  describe '#industry_tags' do
    it "returns a semicolon-delimited list of associated industry names" do
      fellow = build :fellow
      industry_1 = build :industry, name: 'Industry 1'
      industry_2 = build :industry, name: 'Industry 2'
      
      allow(fellow).to receive(:industries).and_return([industry_1, industry_2])
      
      expect(fellow.industry_tags).to eq("Industry 1;Industry 2")
    end
  end

  describe '#industry_tags=' do
    it "converts a semicolon-delimited list of industry names into associations" do
      fellow = create :fellow
      industry_1 =  create :industry, name: 'Industry 1'
      industry_2 =  create :industry, name: 'Industry 2'
      industry_3 =  create :industry, name: 'Industry 3'
      
      fellow.industry_tags = "Industry 1;Industry 2"
      
      expect(fellow.industries).to include(industry_1)
      expect(fellow.industries).to include(industry_2)
      expect(fellow.industries).to_not include(industry_3)
    end
  end
  
  describe '#interest_tags' do
    it "returns a semicolon-delimited list of associated interest names" do
      fellow = build :fellow
      interest_1 = build :interest, name: 'Interest 1'
      interest_2 = build :interest, name: 'Interest 2'
      
      allow(fellow).to receive(:interests).and_return([interest_1, interest_2])
      
      expect(fellow.interest_tags).to eq("Interest 1;Interest 2")
    end
  end

  describe '#interest_tags=' do
    it "converts a semicolon-delimited list of interest names into associations" do
      fellow = create :fellow
      interest_1 =  create :interest, name: 'Interest 1'
      interest_2 =  create :interest, name: 'Interest 2'
      interest_3 =  create :interest, name: 'Interest 3'
      
      fellow.interest_tags = "Interest 1;Interest 2"
      
      expect(fellow.interests).to include(interest_1)
      expect(fellow.interests).to include(interest_2)
      expect(fellow.interests).to_not include(interest_3)
    end
  end
  
  describe '#metro_tags' do
    it "returns a semicolon-delimited list of associated metro names" do
      fellow = build :fellow
      metro_1 = build :metro, name: 'Metro 1'
      metro_2 = build :metro, name: 'Metro 2'
      
      allow(fellow).to receive(:metros).and_return([metro_1, metro_2])
      
      expect(fellow.metro_tags).to eq("Metro 1;Metro 2")
    end
  end

  describe '#metro_tags=' do
    it "converts a semicolon-delimited list of metro names into associations" do
      fellow = create :fellow
      metro_1 =  create :metro, name: 'Metro 1'
      metro_2 =  create :metro, name: 'Metro 2'
      metro_3 =  create :metro, name: 'Metro 3'
      
      fellow.metro_tags = "Metro 1;Metro 2"
      
      expect(fellow.metros).to include(metro_1)
      expect(fellow.metros).to include(metro_2)
      expect(fellow.metros).to_not include(metro_3)
    end
  end
end
