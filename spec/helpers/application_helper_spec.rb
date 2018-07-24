require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe 'link_to_access_token(access_token, label)' do
    let(:code) { 'aaaaaaaaaaaaaaaa' }
    let(:view_route) { {'label' => 'view', 'method' => 'GET', 'path' => '/fellow/home/welcome'} }
    let(:other_route) { {'label' => 'other', 'method' => 'POST', 'path' => '/other?test=true'} }
    let(:access_token) { build :access_token, code: code, routes: [view_route, other_route] }
    
    subject { link_to_access_token(access_token, label) }
    describe "when there are no other parameters" do
      let(:label) { 'view' }
      it { should eq(link_to 'view', "/fellow/home/welcome?token=#{code}", method: 'GET') }
    end
    
    describe "when there are other parameters" do
      let(:label) { 'other' }
      it { should eq(link_to 'other', "/other?test=true&token=#{code}", method: 'POST') }
    end
  end
end
