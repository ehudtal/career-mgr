require 'rails_helper'

RSpec.describe Employer, type: :model do
  
  ##############
  # Associations
  ##############

  
  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  describe 'validating uniqueness' do
    subject { create :employer }
    it { should validate_uniqueness_of :name}
  end
end
