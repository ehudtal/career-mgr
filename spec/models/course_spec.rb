require 'rails_helper'

RSpec.describe Course, type: :model do
  
  ##############
  # Associations
  ##############

  it { should belong_to :site }
  
  it { should have_many :cohorts }
  
  #############
  # Validations
  #############

  it { should validate_presence_of :site_id }
  
  describe "validating uniqueness" do
    subject { create :course }
    it { should validate_uniqueness_of(:site_id).scoped_to([:semester, :year]) }
  end
  
  it { should validate_inclusion_of(:semester).in_array(Course::VALID_SEMESTERS) }
  
  it { should validate_numericality_of(:year).is_greater_than(2010) }
  it { should validate_numericality_of(:year).is_less_than(2030) }
  it { should validate_numericality_of(:year).allow_nil }
  it { should validate_numericality_of(:year).only_integer }
  
  ###########
  # Constants
  ###########

  describe '::VALID_SEMESTERS' do
    subject { Course::VALID_SEMESTERS }
    
    it { is_expected.to include('Fall') }
    it { is_expected.to include('Spring') }
    it { is_expected.to include('Summer') }
    it { is_expected.to include('Q1') }
    it { is_expected.to include('Q2') }
    it { is_expected.to include('Q3') }
    it { is_expected.to include('Q4') }
  end
  
  ##################
  # Instance methods
  ##################

  describe 'label' do
    it "should combine semester and year" do
      course = Course.new semester: 'Fall', year: 2018
      expect(course.label).to eq('Fall 2018')
    end
  end
end
