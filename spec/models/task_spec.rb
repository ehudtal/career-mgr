require 'rails_helper'

RSpec.describe Task, type: :model do
  ##############
  # Associations
  ##############

  it { should belong_to :taskable }

  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  ##########
  # Defaults
  ##########

  it "defaults completed to false" do
    expect(Task.new.completed).to be(false)
  end
end
