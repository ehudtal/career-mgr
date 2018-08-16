require 'rails_helper'

RSpec.describe CareerStep, type: :model do
  let(:career_step) { create :career_step, fellow: fellow }
  let(:fellow) { create :fellow }

  ##############
  # Associations
  ##############

  it { should belong_to :fellow }

  #############
  # Validations
  #############

  [:name, :description].each do |attribute|
    it { should validate_presence_of(attribute) }
  end
  
  ########
  # Scopes
  ########

  describe 'completed' do
    let(:fellow) { create :fellow }
    let(:completed) { create :career_step, fellow: fellow, completed: true }
    let(:not_completed) { create :career_step, fellow: fellow, completed: false }
    
    before { completed; not_completed }
    
    subject { CareerStep.completed }
    
    it { should include(completed) }
    it { should_not include(not_completed) }
  end
end
