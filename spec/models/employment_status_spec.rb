require 'rails_helper'

RSpec.describe EmploymentStatus, type: :model do
  
  ##############
  # Associations
  ##############

  
  #############
  # Validations
  #############

  it { should validate_presence_of :position }
  it { should validate_presence_of :name }
  
  describe 'validating uniqueness' do
    subject { create :employment_status }

    it { should validate_uniqueness_of :position }
    it { should validate_uniqueness_of :name }
  end
end
