require 'rails_helper'

RSpec.describe Major, type: :model do

  ##############
  # Associations
  ##############

  it { should have_and_belong_to_many :fellows }
  it { should have_and_belong_to_many :opportunities }
  
  it { should belong_to :parent }
  it { should have_many :children }

  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  describe "validating uniqueness" do
    subject { create :major }
    it { should validate_uniqueness_of :name }
  end
  
  ###############
  # Class methods
  ###############

  describe '::load_from_yaml' do
    before do
      Major.create name: 'nonexistant'
      Major.load_from_yaml
    end
    
    subject { Major.pluck(:name) }
    
    it "removes pre-existing majors" do
      expect(Major.find_by(name: 'nonexistant')).to be_nil
    end
    
    it "loads categories" do
      expect(subject).to include('Business')
      expect(subject).to include('Education')
    end
    
    it "loads majors" do
      expect(subject).to include("Food Science")
      expect(subject).to include("Accounting")
    end
    
    it "connects parents to children" do
      business = Major.find_by name: 'Business'
      accounting = Major.find_by name: 'Accounting'
      
      expect(business.children).to include(accounting)
      expect(accounting.parent).to eq(business)
    end
  end
  
  ##################
  # Instance methods
  ##################
  
  describe '#all_parents' do
    let(:unrelated) { create :major }
    let(:grandparent) { create :major }
    let(:parent) { create :major, parent: grandparent }
    let(:child) { create :major, parent: parent }
    
    before { unrelated; child }
    
    subject { child.all_parents }
    
    it { should include(grandparent) }
    it { should include(parent) }
    it { should_not include(child) }
    it { should_not include(unrelated) }
  end
  
  describe '#all_children' do
    let(:unrelated) { create :major }
    let(:grandparent) { create :major }
    let(:parent) { create :major, parent: grandparent }
    let(:child) { create :major, parent: parent }
    
    before { unrelated; child }
    
    subject { grandparent.all_children }
    
    it { should include(child) }
    it { should include(parent) }
    it { should_not include(grandparent) }
    it { should_not include(unrelated) }
  end
end
