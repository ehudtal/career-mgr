require 'rails_helper'

RSpec.describe Region, type: :model do
  ##############
  # Associations
  ##############

  it { should have_many :opportunities }
  
  #############
  # Validations
  #############

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:position) }
  
  describe 'validating uniqeness' do
    before { create :region }

    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:position) }
  end
  
  ###############
  # Class methods
  ###############

  describe '::types' do
    subject { Region.types }
    
    it { should be_an(Array) }
    it { expect(subject.size).to eq(4) }
    it { expect(subject.first).to eq('Bay') }
    it { expect(subject.last).to eq('Nationwide') }
  end
end
