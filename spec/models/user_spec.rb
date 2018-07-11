require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }
  
  #############
  # Validations
  #############

  it { should validate_presence_of :email }
  
  describe 'validating uniqueness' do
    before { user }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end
end
