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
  
  describe 'validating uniqeness' do
    before { create :region }
    it { should validate_uniqueness_of(:name) }
  end
end
