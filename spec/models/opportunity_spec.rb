require 'rails_helper'

RSpec.describe Opportunity, type: :model do
  
  ##############
  # Associations
  ##############

  it { should belong_to :employer }
  
  #############
  # Validations
  #############

  it { should validate_presence_of :employer_id }
end
