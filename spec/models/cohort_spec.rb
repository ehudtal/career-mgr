require 'rails_helper'

RSpec.describe Cohort, type: :model do
  ##############
  # Associations
  ##############

  it { should have_one :contact }
  it { should belong_to :course }
  it { should have_many :cohort_fellows }
  it { should have_many :fellows }
  
  it { should have_and_belong_to_many :coaches }
  
  #############
  # Validations
  #############
  
  it { should validate_presence_of :name }
  
  describe "validating uniqueness" do
    subject { create :cohort }
    it { should validate_uniqueness_of(:name).scoped_to(:course_id) }
  end
end
