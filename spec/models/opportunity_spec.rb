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
  
  ###############
  # Normalization
  ###############

  describe 'normalizing job posting url' do
    let(:url_without_protocol) { 'example.com' }
    let(:url_with_protocol) { 'http://example.com' }
    
    it "adds protocol if missing" do
      opportunity = Opportunity.new job_posting_url: url_without_protocol
      opportunity.send(:normalize_url)
      
      expect(opportunity.job_posting_url).to eq url_with_protocol
    end
    
    it "doesn't add protocol if already included" do
      opportunity = Opportunity.new job_posting_url: url_with_protocol
      opportunity.send(:normalize_url)
      
      expect(opportunity.job_posting_url).to eq url_with_protocol
    end
    
    it "doesn't add protocol of url is blank" do
      opportunity = Opportunity.new job_posting_url: ''
      opportunity.send(:normalize_url)
      
      expect(opportunity.job_posting_url).to eq ''
    end
    
    it "normalizes before save" do
      opportunity = Opportunity.new attributes_for(:opportunity)

      allow(opportunity).to receive(:employer).and_return(employer)
      expect(opportunity).to receive(:normalize_url)

      opportunity.save
    end
  end
end
