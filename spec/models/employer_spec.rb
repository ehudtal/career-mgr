require 'rails_helper'

RSpec.describe Employer, type: :model do
  
  ##############
  # Associations
  ##############
  
  it { should have_many :opportunities }

  it { should have_and_belong_to_many :coaches }
  it { should have_and_belong_to_many :industries }
  it { should have_and_belong_to_many :locations }
  
  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  describe 'validating uniqueness' do
    subject { create :employer }
    it { should validate_uniqueness_of :name}
  end
end
