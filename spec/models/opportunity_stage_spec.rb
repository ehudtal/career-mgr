require 'rails_helper'

RSpec.describe OpportunityStage, type: :model do
  
  ##############
  # Associations
  ##############
  
  it { should have_many :fellow_opportunities }

  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  it { should validate_presence_of :position }
  it { should validate_presence_of :probability }
  
  it { should validate_numericality_of(:position).only_integer.is_greater_than_or_equal_to(0) }
  
  describe 'validating uniqueness' do
    subject { create :opportunity_stage }
    
    it { should validate_uniqueness_of :name }
    it { should validate_uniqueness_of :position }
  end

  it { should validate_numericality_of(:probability).is_greater_than_or_equal_to(0.0) }
  it { should validate_numericality_of(:probability).is_less_than_or_equal_to(1.0) }
  it { should validate_numericality_of(:probability).allow_nil }
  
  ########
  # Scopes
  ########
  
  describe '::togglable' do
    it "filters to togglable opp stages" do
      show_2 = create :opportunity_stage, name: 'show 2', togglable: true, position: 2
      hide_1 = create :opportunity_stage, name: 'hide 1', togglable: false, position: 1
      show_1 = create :opportunity_stage, name: 'show 1', togglable: true, position: 0
      
      expect(OpportunityStage.togglable).to eq([show_1, show_2])
    end
  end
  
  ###############
  # Class methods
  ###############

  describe '::togglable_names' do
    it "shows the names of togglable opp stages" do
      show_2 = create :opportunity_stage, name: 'show 2', togglable: true, position: 2
      hide_1 = create :opportunity_stage, name: 'hide 1', togglable: false, position: 1
      show_1 = create :opportunity_stage, name: 'show 1', togglable: true, position: 0
    
      expect(OpportunityStage.togglable_names).to eq([show_1.name, show_2.name])
    end
  end
end
