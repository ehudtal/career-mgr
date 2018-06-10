require 'rails_helper'

RSpec.describe Opportunity, type: :model do
  let(:employer) { build :employer }
  
  ##############
  # Associations
  ##############

  it { should belong_to :employer }
  
  it { should have_many :tasks }
  
  it { should have_and_belong_to_many :industries }
  it { should have_and_belong_to_many :interests }
  it { should have_and_belong_to_many :locations }
  
  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  describe 'validating job_posting_url' do
    it "rejects invalid urls" do
      opportunity = Opportunity.new job_posting_url: 'a b c'
      
      expect(opportunity).to_not be_valid
      expect(opportunity.errors[:job_posting_url]).to include('is an invalid URL')
    end
    
    it "allows blank urls" do
      opportunity = Opportunity.new
      opportunity.valid?
      
      expect(opportunity.errors[:job_posting_url]).to_not include('is an invalid URL')
    end
    
    it "sets the protocol if missing" do
      url = 'example.com'
      opportunity = Opportunity.new job_posting_url: url
      opportunity.valid?

      expect(opportunity.job_posting_url).to eq("http://#{url}")
    end
  end
end
