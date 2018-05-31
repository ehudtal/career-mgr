require 'rails_helper'

RSpec.describe Contact, type: :model do
  
  ##############
  # Associations
  ##############

  it { should belong_to :contactable }
  
  #############
  # Validations
  #############
  
  def self.required_fields
    [:contactable_id, :contactable_type]
  end
  
  required_fields.each do |attribute|
    it { should validate_presence_of attribute }
  end
  
  describe "uniqueness" do
    subject { create :contact }
    it { should validate_uniqueness_of(:contactable_id).scoped_to(:contactable_type) }
  end
end
