require 'rails_helper'

RSpec.describe Opportunity, type: :model do
  
  ##############
  # Associations
  ##############

  it { should belong_to :employer }
  
  it { should have_and_belong_to_many :industries }
  it { should have_and_belong_to_many :interests }
  it { should have_and_belong_to_many :locations }
  
  #############
  # Validations
  #############

  it { should validate_presence_of :employer_id }
  it { should validate_presence_of :name }
end
