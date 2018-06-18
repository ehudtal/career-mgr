require 'rails_helper'

RSpec.describe Comment, type: :model do
  ##############
  # Associations
  ##############

  it { should belong_to(:commentable) }
end
