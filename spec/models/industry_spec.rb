require 'rails_helper'

RSpec.describe Industry, type: :model do
  ##############
  # Associations
  ##############


  #############
  # Validations
  #############
  
  it { should validate_presence_of :name }
  
  describe "validating uniqueness" do
    subject { create :industry }
    it { should validate_uniqueness_of :name }
  end
end
