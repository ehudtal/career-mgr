require 'rails_helper'
require 'support/taggable_helpers'

RSpec.describe Employer, type: :model do
  
  ##############
  # Associations
  ##############
  
  it { should have_many :opportunities }
  it { should have_many :locations }

  it { should have_and_belong_to_many :coaches }
  it { should have_and_belong_to_many :industries }
  
  it_behaves_like 'taggable', :employer, :industry
  
  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  describe 'validating uniqueness' do
    subject { create :employer }
    it { should validate_uniqueness_of :name}
  end
  
  ##################
  # Instance methods
  ##################
  
  describe '#industry_tags' do
    it "returns a semicolon-delimited list of associated industry names" do
      employer = build :employer
      industry_1 = build :industry, name: 'Industry 1'
      industry_2 = build :industry, name: 'Industry 2'
      
      allow(employer).to receive(:industries).and_return([industry_1, industry_2])
      
      expect(employer.industry_tags).to eq("Industry 1;Industry 2")
    end
  end

  describe '#industry_tags=' do
    it "converts a semicolon-delimited list of industry names into associations" do
      employer = create :employer
      industry_1 =  create :industry, name: 'Industry 1'
      industry_2 =  create :industry, name: 'Industry 2'
      industry_3 =  create :industry, name: 'Industry 3'
      
      employer.industry_tags = "Industry 1;Industry 2"
      
      expect(employer.industries).to include(industry_1)
      expect(employer.industries).to include(industry_2)
      expect(employer.industries).to_not include(industry_3)
    end
  end
end
