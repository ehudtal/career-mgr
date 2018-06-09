require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:locateable) { build :employer }
  
  ##############
  # Associations
  ##############

  it { should belong_to :locateable }
  it { should have_one :contact }

  it { should have_and_belong_to_many :opportunities }
  
  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  describe "validating uniqueness" do
    subject { create :location, locateable: locateable }
    it { should validate_uniqueness_of(:name) }
  end
end
