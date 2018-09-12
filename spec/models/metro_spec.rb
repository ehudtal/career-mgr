require 'rails_helper'

RSpec.describe Metro, type: :model do
  ##############
  # Associations
  ##############

  it { should have_and_belong_to_many :opportunities }
  it { should have_and_belong_to_many :fellows }
  
  it { should have_and_belong_to_many :parents }
  it { should have_and_belong_to_many :children }
  
  #############
  # Validations
  #############
  
  it { should validate_presence_of :code }
  it { should validate_presence_of :name }
  
  describe 'validating uniqueness' do
    before { create :metro }
    
    it { should validate_uniqueness_of(:code).case_insensitive }
    it { should validate_uniqueness_of(:name) }
  end
  
  ########
  # Scopes
  ########

  describe 'city/state scopes' do
    let(:city1) { create :metro, source: 'MSA' }
    let(:city2) { create :metro, source: 'SMSA' }
    let(:state) { create :metro, source: 'ST' }
    let(:anywhere) { create :metro, source: 'ANY' }
    
    before { city1; city2; state; anywhere }
    
    describe 'city' do
      subject { Metro.city }
      
      it { should include(city1) }
      it { should include(city2) }
      it { should_not include (state) }
      it { should_not include(anywhere) }
    end
    
    describe 'state' do
      subject { Metro.state }
      
      it { should_not include(city1) }
      it { should_not include(city2) }
      it { should include (state) }
      it { should_not include(anywhere) }
    end
  end
  
  ###############
  # Class methods
  ###############
  
  describe '::load_txt' do
    it "loads the contents of the TXT file into the db" do
      Metro.load_txt("#{Rails.root}/spec/fixtures/msa-sample.txt")
      expect(Metro.count).to eq(5)

      metro = Metro.find_by code: '0040'
      expect(metro.name).to eq("Abilene, TX")
    end
    
    it "clears table first" do
      create :metro
      Metro.load_txt("#{Rails.root}/spec/fixtures/msa-sample.txt")

      expect(Metro.count).to eq(5)
    end
  end
  
  ##################
  # Instance methods
  ##################

  describe '#states' do
    it "returns empty when states aren't supplied" do
      metro = Metro.new name: 'Lincoln'
      expect(metro.states).to eq([])
    end
    
    it "returns the states with city,state formatted name" do
      metro = Metro.new name: 'Lincoln,NE'
      expect(metro.states).to eq(['NE'])
    end
    
    it "returns the states with 'city, state' format" do
      metro = Metro.new name: 'Lincoln, NE'
      expect(metro.states).to eq(['NE'])
    end
    
    it "returns the states when there are more than one" do
      metro = Metro.new name: 'Omaha,NE-IA'
      
      expect(metro.states.size).to eq(2)
      expect(metro.states).to include('NE')
      expect(metro.states).to include('IA')
    end
  end

  describe 'ancestry' do
    let(:unrelated) { create :metro }
    let(:grandparent) { create :metro }
    let(:parent) { create :metro }
    let(:child) { create :metro }
    let(:sibling) { create :metro }
    let(:uncle) { create :metro }
    let(:cousin) { create :metro }
  
    before do
      grandparent.children << parent
      grandparent.children << uncle
      
      parent.children << child
      parent.children << sibling
      
      uncle.children << cousin
      
      unrelated
    end
  
    describe '#all_parents' do
      subject { child.all_parents }
    
      it { should_not include(child) }
      it { should include(parent) }
      it { should include(grandparent) }
      it { should_not include(uncle) }
      it { should_not include(sibling) }
      it { should_not include(cousin) }
      it { should_not include(unrelated) }
    end
  
    describe '#all_children' do
      subject { grandparent.all_children }
    
      it { should include(child) }
      it { should include(parent) }
      it { should include(uncle) }
      it { should include(sibling) }
      it { should include(cousin) }
      it { should_not include(grandparent) }
      it { should_not include(unrelated) }
    end
  end
end
