require 'rails_helper'

RSpec.describe FellowOpportunity, type: :model do
  
  ##############
  # Associations
  ##############

  it { should belong_to :fellow }
  it { should belong_to :opportunity }
  it { should belong_to :opportunity_stage }
  
  it { should have_many :comments }
  
  #############
  # Validations
  #############
  
  it { should validate_presence_of :fellow_id }
  it { should validate_presence_of :opportunity_id }
  it { should validate_presence_of :opportunity_stage_id }
  
  describe 'validating uniqueness' do
    subject { create :fellow_opportunity }
    it { should validate_uniqueness_of(:fellow_id).scoped_to(:opportunity_id) }
  end
end
