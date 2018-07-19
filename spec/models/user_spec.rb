require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }
  
  ##############
  # Associations
  ##############

  it { should have_one :fellow }

  #############
  # Validations
  #############

  it { should validate_presence_of :email }
  
  describe 'validating uniqueness' do
    before { user }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end
  
  ###########
  # Callbacks
  ###########

  describe 'fellow/user matching attempt' do
    it "executes upon create" do
      new_user = build :user
      expect(FellowUserMatcher).to receive(:match).with(new_user.email).once

      new_user.save
    end
    
    it "executes upon save, if no fellow already associated" do
      user
      expect(FellowUserMatcher).to receive(:match).with(user.email).once

      user.save
    end
    
    it 'does not execut when fellow is already associated' do
      create :fellow, user_id: user.id
      user.reload
      
      expect(FellowUserMatcher).to receive(:match).with(user.email).never

      user.save
    end
  end

  ##################
  # Instance methods
  ##################

  describe '#role' do
    subject { user.role }
    
    describe 'when admin and fellow' do
      let(:user) { build :user, is_admin: true, is_fellow: true }
      it { expect(subject).to eq(:admin) }
    end
    
    describe 'when admin and not fellow' do
      let(:user) { build :user, is_admin: true, is_fellow: false }
      it { expect(subject).to eq(:admin) }
    end
    
    describe 'when not admin and fellow' do
      let(:user) { build :user, is_admin: false, is_fellow: true }
      it { expect(subject).to eq(:fellow) }
    end
    
    describe 'when not admin and not fellow' do
      let(:user) { build :user, is_admin: false, is_fellow: false }
      it { expect(subject).to eq(:fellow) }
    end
  end
end
