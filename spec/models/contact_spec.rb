require 'rails_helper'

RSpec.describe Contact, type: :model do
  
  ##############
  # Associations
  ##############

  it { should belong_to :contactable }
  
  #############
  # Validations
  #############
  
  it { should validate_inclusion_of(:state).in_array(Contact::STATES) }
  
  it_behaves_like "valid url", :url, allow_blank: true
  
  ##################
  # Instance methods
  ##################

  describe '#metro' do
    let(:msa_code) { '1230' }
    let(:zip) { '10001' }
    
    let(:metro) { create :metro, code: msa_code }
    let(:postal_code) { create :postal_code, code: zip, msa_code: msa_code }
    let(:contact) { create :contact, postal_code: zip }

    it "associates the contact with the metro via zip/msa_code" do
      postal_code
      metro
      
      expect(contact.metro).to eq(metro)
    end
    
    it "returns nil when postal code doesn't exist" do
      metro
      expect(contact.metro).to be_nil
    end
    
    it "returns nil when metro doesn't exist" do
      postal_code
      expect(contact.metro).to be_nil
    end
  end
  
  describe '#metro_name' do
    let(:msa_code) { '1230' }
    let(:zip) { '10001' }

    let(:metro) { create :metro, code: msa_code }
    let(:postal_code) { create :postal_code, code: zip, msa_code: msa_code }
    let(:contact) { create :contact, postal_code: zip }
    
    it 'returns metro name when zip/metro exists' do
      postal_code
      metro
      
      expect(contact.metro_name).to eq(metro.name)
    end

    it "returns nil when metro doesn't exist" do
      postal_code
      expect(contact.metro_name).to be_nil
    end

    it "returns nil when zip doesn't exist" do
      metro
      expect(contact.metro_name).to be_nil
    end
  end
end
