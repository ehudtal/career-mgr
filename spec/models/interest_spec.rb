require 'rails_helper'

RSpec.describe Interest, type: :model do

  ##############
  # Associations
  ##############


  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  describe "validating uniqueness" do
    subject { create :interest }
    it { should validate_uniqueness_of :name }
  end
end
