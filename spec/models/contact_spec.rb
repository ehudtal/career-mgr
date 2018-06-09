require 'rails_helper'

RSpec.describe Contact, type: :model do
  
  ##############
  # Associations
  ##############

  it { should belong_to :contactable }
  
  #############
  # Validations
  #############
  
  it { should validate_inclusion_of(:state).in_array(Contact::STATES) }
  
  it_behaves_like "valid url", :url
end
