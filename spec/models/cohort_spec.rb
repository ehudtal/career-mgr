require 'rails_helper'

RSpec.describe Cohort, type: :model do
  ##############
  # Associations
  ##############

  it { should have_one :contact }
  it { should belong_to :course }
  it { should have_many :cohort_fellows }
  it { should have_many :fellows }
  
  it { should have_and_belong_to_many :coaches }
  
  #############
  # Validations
  #############
  
  it { should validate_presence_of :name }
  
  describe "validating uniqueness" do
    subject { create :cohort }
    it { should validate_uniqueness_of(:name).scoped_to(:course_id) }
  end
  
  ##################
  # Instance methods
  ##################
  
  describe '#fellows.unique(attributes)' do
    let(:cohort) { create :cohort}
    let(:fellow) { create :fellow, contact: contact }
    let(:contact) { create :contact }
    let(:attributes) { {first_name: fellow.first_name, last_name: fellow.last_name, email: contact.email, phone: contact.phone} }
    
    before do
      cohort.fellows << fellow
    end
    
    it "recognizes an exact name/phone/email match" do
      expect(cohort.fellows.unique(attributes)).to eq(fellow)
    end
    
    it "accepts extra parameters" do
      attributes[:extra] = 'extra'
      expect(cohort.fellows.unique(attributes)).to eq(fellow)
    end
    
    it "recognizes fellow when phone has changed" do
      attributes[:phone] = '111-222-3333'
      expect(cohort.fellows.unique(attributes)).to eq(fellow)
    end
    
    it "recognizes fellow when email has changed" do
      attributes[:email] = 'nothing@example.com'
      expect(cohort.fellows.unique(attributes)).to eq(fellow)
    end
    
    it "recognizes fellow when first name has changed" do
      attributes[:first_name] = 'nothing'
      expect(cohort.fellows.unique(attributes)).to eq(fellow)
    end

    it "recognizes fellow when last name has chaned" do
      attributes[:last_name] = 'nothing'
      expect(cohort.fellows.unique(attributes)).to eq(fellow)
    end
    
    it "does not recognize fellow when phone AND e-mail are different" do
      attributes[:phone] = '111-222-3333'
      attributes[:email] = 'nothing@example.com'
      
      expect(cohort.fellows.unique(attributes)).to be_nil
    end
  end
  
  describe '#fellows.create_or_update(attributes)' do
    it "updates when it recognizes the fellow" do
      contact = create :contact
      fellow = create :fellow, contact: contact
      cohort = create :cohort
      attributes = {first_name: fellow.first_name, last_name: fellow.last_name, phone: contact.phone, email: contact.email}
      
      allow(cohort.fellows).to receive(:unique).with(attributes).and_return(fellow)
      
      attributes[:first_name] = 'NewFirstName'
      cohort.fellows.create_or_update(attributes)
      
      expect(fellow.reload.first_name).to eq('NewFirstName')
    end
    
    it "creates when it doesn't recognize the fellow" do
      cohort = create :cohort
      create :employment_status_unemployed
      
      attributes = {first_name: 'Bob', last_name: 'Smith', email: 'bob@example.com', phone: '111-222-3333'}
      
      cohort.fellows.create_or_update(attributes)
      fellow = cohort.fellows.first
      
      expect(fellow.first_name).to eq(attributes[:first_name])
      expect(fellow.last_name).to eq(attributes[:last_name])
      expect(fellow.contact.email).to eq(attributes[:email])
      expect(fellow.contact.phone).to eq(attributes[:phone])
    end
  end
end
