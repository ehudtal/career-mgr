require 'rails_helper'
require 'fellow_user_matcher'

RSpec.describe FellowUserMatcher do
  let(:email) { 'matching@example.com' }
  
  let(:user_match) { create :fellow_user, email: email }
  let(:user_nomatch) { create :fellow_user }
  
  let(:fellow_match) { create :fellow }
  let(:contact) { create :contact, contactable: fellow_match, email: email }
  let(:fellow_nomatch) { create :fellow }
  
  before do
    user_match; user_nomatch
    fellow_match; fellow_nomatch
    contact
  end
  
  subject { FellowUserMatcher.match(email) }
  
  describe "::match(email)" do
    before { subject }
    
    it "associates a fellow to a matching user" do
      expect(user_match.reload.fellow).to eq(fellow_match)
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