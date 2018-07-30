require 'rails_helper'

RSpec.describe CandidateLog, type: :model do
  ##############
  # Associations
  ##############

  it { should belong_to :candidate }
end
