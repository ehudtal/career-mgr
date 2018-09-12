require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:locateable) { build :employer }
  
  ##############
  # Associations
  ##############

  it { should belong_to :locateable }
  it { should have_one :contact }

  it { should have_and_belong_to_many :opportunities }
  
  #############
  # Validations
  #############

  describe "validating uniqueness" do
    subject { create :location, locateable: locateable }
    it { should validate_uniqueness_of(:name).scoped_to([:locateable_id, :locateable_type]) }
  end
  
  ##################
  # Instance methods
  ##################

  describe '#label' do
    let(:contact) { build :contact, address_1: '123 Way Street', city: 'Lincoln', state: 'NE' }
    let(:location) { build :location, name: 'Headquarters', contact: contact }
    
    it "uses name and address" do
      expect(location.label).to eq("Headquarters: 123 Way Street Lincoln, NE")
    end
  end
end
