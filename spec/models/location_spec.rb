require 'rails_helper'

RSpec.describe Location, type: :model do
  
  ##############
  # Associations
  ##############

  it { should have_one :contact }
  
  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  describe "validating uniqueness" do
    subject { create :location }
    it { should validate_uniqueness_of(:name) }
  end
end
