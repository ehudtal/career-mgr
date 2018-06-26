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
  
  describe '#unique_fellow(attributes)' do
    let(:cohort) { build :cohort}
    let(:fellow) { build :fellow }
    let(:contact) { build :contact }
    let(:attributes) { {first_name: fellow.first_name, last_name: fellow.last_name, email: contact.email, phone: contact.phone} }
    
    before do
      allow(cohort).to receive(:fellows).and_return([fellow])
      allow(fellow).to receive(:contact).and_return(contact)
    end
    
    it "recognizes an exact name/phone/email match" do
      expect(cohort.unique_fellow(attributes)).to eq(fellow)
    end
    
    it "accepts extra parameters" do
      attributes[:extra] = 'extra'
      expect(cohort.unique_fellow(attributes)).to eq(fellow)
    end
    
    it "recognizes fellow when phone has changed" do
      attributes[:phone] = '111-222-3333'
      expect(cohort.unique_fellow(attributes)).to eq(fellow)
    end
    
    it "recognizes fellow when email has changed" do
      attributes[:email] = 'nothing@example.com'
      expect(cohort.unique_fellow(attributes)).to eq(fellow)
    end
    
    it "recognizes fellow when first name has changed" do
      attributes[:first_name] = 'nothing'
      expect(cohort.unique_fellow(attributes)).to eq(fellow)
    end

    it "recognizes fellow when last name has chaned" do
      attributes[:last_name] = 'nothing'
      expect(cohort.unique_fellow(attributes)).to eq(fellow)
    end
    
    it "does not recognize fellow when phone AND e-mail are different" do
      attributes[:phone] = '111-222-3333'
      attributes[:email] = 'nothing@example.com'
      
      expect(cohort.unique_fellow(attributes)).to be_nil
    end
  end
end
