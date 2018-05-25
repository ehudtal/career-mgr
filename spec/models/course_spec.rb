require 'rails_helper'

RSpec.describe Course, type: :model do
  
  ##############
  # Associations
  ##############

  it { should belong_to :site }
  
  it { should have_many :cohorts }
  
  #############
  # Validations
  #############

  it { should validate_presence_of :site_id }
  
  describe "validating uniqueness" do
    subject { create :course }
    it { should validate_uniqueness_of(:site_id).scoped_to([:semester, :year]) }
  end
end
