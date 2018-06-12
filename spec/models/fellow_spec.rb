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
end
