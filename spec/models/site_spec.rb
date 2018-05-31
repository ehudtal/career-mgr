require 'rails_helper'

RSpec.describe Site, type: :model do
  
  ##############
  # Associations
  ##############
  
  it { should have_many :courses }

  #############
  # Validations
  #############

  it { should validate_presence_of(:name) }
  
  describe "validating uniqueness" do
    subject { create :site }
    it { should validate_uniqueness_of(:name) }
  end
end
