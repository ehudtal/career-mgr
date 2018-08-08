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
end
