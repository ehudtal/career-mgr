require 'rails_helper'
require 'geo_distance'

RSpec.describe PostalCode, type: :model do
  #############
  # Validations
  #############

  it { should validate_presence_of :code }
  it { should validate_presence_of :latitude }
  it { should validate_presence_of :longitude }
  
  describe 'validating uniqueness' do
    before { create :postal_code }
    it { should validate_uniqueness_of(:code).case_insensitive }
  end
  
  it { should validate_numericality_of(:latitude).is_greater_than(18.0).is_less_than(72.0) }
  it { should validate_numericality_of(:longitude).is_greater_than(-160.0).is_less_than(-50.0) }
  
  ###############
  # Class methods
  ###############

  describe '::distance' do
    let(:origin) { build :postal_code, latitude: 45.0, longitude: -105 }
    let(:destination) { build :postal_code, latitude: 50.0, longitude: -95 }
    let(:distance) { 123.0 }
    
    before do
      allow(PostalCode).to receive(:find_by).with(code: origin.code).and_return(origin)
      allow(PostalCode).to receive(:find_by).with(code: destination.code).and_return(destination)
      
      allow(GeoDistance).to receive(:haversine).with(origin.coordinates, destination.coordinates).and_return(distance)
    end
    
    it "calculats the haversine distance between the two postal codes" do
      expect(PostalCode.distance(origin.code, destination.code)).to eq(distance)
    end
  end
  
  describe '::load_csv' do
    it "loads the contents of the CSV file into the db, weeding out duplicates" do
      PostalCode.load_csv("#{Rails.root}/spec/fixtures/postal-code-sample.csv")
      expect(PostalCode.count).to eq(2)

      postal_code = PostalCode.find_by code: '00501'
      expect(postal_code.lat).to be_within(0.00001).of(40.813078)
      expect(postal_code.lon).to be_within(0.00001).of(-73.046388)
    end
    
    it "clears table first" do
      create :postal_code
      PostalCode.load_csv("#{Rails.root}/spec/fixtures/postal-code-sample.csv")

      expect(PostalCode.count).to eq(2)
    end
  end
  
  ##################
  # Instance methods
  ##################
  
  describe '#coordinates' do
    it "provides an array of [latitude, longitude]" do
      postal_code = PostalCode.new lat: 44.0, lon: -100.0
      expect(postal_code.coordinates).to eq([44.0, -100.0])
    end
  end
  
  describe '#coordinates=' do
    it "sets an array to latitude, longitude" do
      postal_code = PostalCode.new
      postal_code.coordinates = [44.0, -100.0]
      
      expect(postal_code.lat).to eq(44.0)
      expect(postal_code.lon).to eq(-100.0)
    end
  end

  describe '#lat' do
    it "is shorthand for latitude" do
      postal_code = PostalCode.new latitude: 44.0
      expect(postal_code.lat).to eq(44.0)
    end
  end
  
  describe '#lat=' do
    it "is shorthand for setting latitude" do
      postal_code = PostalCode.new
      postal_code.lat = 44.0
      
      expect(postal_code.latitude).to eq(44.0)
    end
  end

  describe '#lon' do
    it "is shorthand for longitude" do
      postal_code = PostalCode.new longitude: -100.0
      expect(postal_code.lon).to eq(-100.0)
    end
  end
  
  describe '#lon=' do
    it "is shorthand for setting longitude" do
      postal_code = PostalCode.new
      postal_code.lon = -100.0
      
      expect(postal_code.longitude).to eq(-100.0)
    end
  end
  
  describe '#metro' do
    let(:postal_code) { create :postal_code, msa_code: '0000', state: 'NE' }
    let(:state) { create :metro, code: state_code, name: 'Nebraska (Statewide)' }
    let(:metro) { create :metro, code: metro_code }
    
    subject { postal_code.metro }
    
    before { postal_code; metro }
    
    describe 'when postal code maps to an existing metro' do
      let(:metro_code) { postal_code.msa_code }
      let(:state_code) { postal_code.state }

      it { should eq(metro) }
      
      it "memoizes the result" do
        expect(Metro).to receive(:find_by).with(code: postal_code.msa_code).once.and_return(metro)
        2.times { postal_code.metro }
      end
    end
    
    describe 'when postal code does NOT map to an existing metro, but state exists' do
      let(:metro_code) { '1111' }
      let(:state_code) { postal_code.state }

      it { should eq(state) }
      
      it "memoizes the result" do
        expect(Metro).to receive(:find_by).with(code: postal_code.msa_code).once.and_return(nil)
        expect(Metro).to receive(:find_by).with(code: postal_code.state).once.and_return(nil)

        2.times { postal_code.metro }
      end
    end
    
    describe 'when postal code does NOT map to an existing metro, and state does NOT exist' do
      let(:metro_code) { '1111' }
      let(:state_code) { 'NA' }

      it { should be_nil }
      
      it "memoizes the result" do
        expect(Metro).to receive(:find_by).with(code: postal_code.msa_code).once.and_return(nil)
        expect(Metro).to receive(:find_by).with(code: postal_code.state).once.and_return(nil)

        2.times { postal_code.metro }
      end
    end
  end
end
