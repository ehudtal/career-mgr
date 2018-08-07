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
end
