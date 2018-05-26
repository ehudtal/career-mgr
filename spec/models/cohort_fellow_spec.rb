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
  
  it { should validate_numericality_of(:grade).is_less_than_or_equal_to(1.0) }
  it { should validate_numericality_of(:grade).is_greater_than_or_equal_to(0.0) }
  it { should validate_numericality_of(:grade).allow_nil }
  
  it { should validate_numericality_of(:attendance).is_less_than_or_equal_to(1.0) }
  it { should validate_numericality_of(:attendance).is_greater_than_or_equal_to(0.0) }
  it { should validate_numericality_of(:attendance).allow_nil }
  
  it { should validate_numericality_of(:nps_response).only_integer }
  it { should validate_numericality_of(:nps_response).is_less_than_or_equal_to(10) }
  it { should validate_numericality_of(:nps_response).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:nps_response).allow_nil }
  
  it { should validate_numericality_of(:endorsement).only_integer }
  it { should validate_numericality_of(:endorsement).is_less_than_or_equal_to(10) }
  it { should validate_numericality_of(:endorsement).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:endorsement).allow_nil }
  
  it { should validate_numericality_of(:professionalism).only_integer }
  it { should validate_numericality_of(:professionalism).is_less_than_or_equal_to(10) }
  it { should validate_numericality_of(:professionalism).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:professionalism).allow_nil }
  
  it { should validate_numericality_of(:teamwork).only_integer }
  it { should validate_numericality_of(:teamwork).is_less_than_or_equal_to(10) }
  it { should validate_numericality_of(:teamwork).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:teamwork).allow_nil }
end
