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
