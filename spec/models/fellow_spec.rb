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
