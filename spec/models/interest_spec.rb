require 'rails_helper'

RSpec.describe Interest, type: :model do

  ##############
  # Associations
  ##############

  it { should have_and_belong_to_many :fellows }
  it { should have_and_belong_to_many :opportunities }

  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  describe "validating uniqueness" do
    subject { create :interest }
    it { should validate_uniqueness_of :name }
  end
end
