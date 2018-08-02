require 'rails_helper'
require 'fellow_user_matcher'

RSpec.describe FellowUserMatcher do
  let(:email) { 'matching@example.com' }
  let(:email_nomatch) { 'nonmatching@example.com' }
  
  let(:user_match) { create :user, is_fellow: false, email: email }
  let(:user_nomatch) { create :user, is_fellow: false }
  
  let(:fellow_match) { create :fellow }
  let(:contact) { create :contact, contactable: fellow_match, email: email }
  let(:fellow_nomatch) { create :fellow }
  
  before do
    user_match; user_nomatch
    fellow_match; fellow_nomatch
    contact
  end
  
  describe '::match(email)?' do
    subject { FellowUserMatcher.match?(this_email) }
    
    describe 'when email matches a fellow' do
      let(:this_email) { email }
      it { should be(true) }
    end
    
    describe 'when email doesn\'t match a fellow' do
      let(:this_email) { email_nomatch }
      it { should be(false) }
    end
  end
  
  describe "::match(email)" do
    subject { FellowUserMatcher.match(email) }

    before { subject }
    
    it "associates a fellow to a matching user" do
      expect(user_match.reload.fellow).to eq(fellow_match)
    end
    
    it "assigns user to the fellow role" do
      expect(user_match.reload.is_fellow?).to be(true)
    end
    
    it "associates a user to a matching fellow" do
      expect(fellow_match.reload.user).to eq(user_match)
    end
    
    it "doesn't associate a fellow to a non-matching user" do
      expect(user_nomatch.fellow).to be_nil
    end

    it "doesn't associate a user to a non-matching fellow" do
      expect(fellow_nomatch.user).to be_nil
    end
  end
end