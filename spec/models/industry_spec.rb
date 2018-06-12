require 'rails_helper'

RSpec.describe Industry, type: :model do
  ##############
  # Associations
  ##############
  
  it { should have_and_belong_to_many :employers }
  it { should have_and_belong_to_many :opportunities }
  it { should have_and_belong_to_many :fellows }

  #############
  # Validations
  #############
  
  it { should validate_presence_of :name }
  
  describe "validating uniqueness" do
    subject { create :industry }
    it { should validate_uniqueness_of :name }
  end
end
