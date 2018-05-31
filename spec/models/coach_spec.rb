require 'rails_helper'

RSpec.describe Coach, type: :model do
  
  ##############
  # Associations
  ##############

  it { should have_one :contact }
  
  it { should have_and_belong_to_many :cohorts }
  it { should have_and_belong_to_many :employers }
  
  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  describe 'validating uniqueness' do
    subject { create :coach }
    it { should validate_uniqueness_of :name }
  end
end
