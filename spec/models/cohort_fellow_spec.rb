require 'rails_helper'

RSpec.describe CohortFellow, type: :model do
  
  ##############
  # Associations
  ##############

  it { should belong_to :cohort }
  it { should belong_to :fellow }

  #############
  # Validations
  #############
  
  def self.required_fields
    [:cohort_id, :fellow_id]
  end
  
  required_fields.each do |attribute|
    it { should validate_presence_of attribute }
  end
  
  describe "validating uniqueness" do
    it { should validate_uniqueness_of(:cohort_id).scoped_to(:fellow_id) }
  end
end
