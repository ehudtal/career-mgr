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
    let(:view_route) { {'label' => 'view', 'method' => 'GET', 'params' => {'controller' => 'fellow/home', 'action' => 'welcome'}} }
    let(:other_route) { {'label' => 'other', 'method' => 'POST', 'params' => {'controller' => 'admin/employers', 'action' => 'index', 'test' => 'true'}} }
    let(:access_token) { build :access_token, code: code, routes: [view_route, other_route] }
    
    subject { link_to_access_token(access_token, label) }

    describe "when there are no other parameters" do
      let(:label) { 'view' }
      it { should eq(link_to 'view', "http://localhost:3011/fellow/home/welcome?token=#{code}".html_safe, method: 'GET') }
    end
    
    describe "when there are other parameters" do
      let(:label) { 'other' }
      it { should eq(link_to('other', "http://localhost:3011/admin/employers?test=true&token=#{code}".html_safe, method: 'POST')) }
    end
  end
  
  describe 'interpolate' do
    it "uses ERB interpolation" do
      @answer = 'three'
      string = "one plus two is <%= @answer %>"
      
      expect(interpolate(string)).to eq('one plus two is three'.html_safe)
    end
    
    it "returns a blank string if nil string is sent" do
      expect(interpolate(nil)).to eq('')
    end
  end
  
  describe 'split_list' do
    it "splits odd list into two parts, biggest part first" do
      list = [:a, :b, :c, :d, :e]
      split = split_list(list)
      
      expect(split[0]).to eq([:a, :b, :c])
      expect(split[1]).to eq([:d, :e])
    end
    
    it "splits even list into equal parts" do
      list = [:a, :b, :c, :d]
      split = split_list(list)
      
      expect(split[0]).to eq([:a, :b])
      expect(split[1]).to eq([:c, :d])
    end
    
    it "sorts items before splitting" do
      list = [:b, :c, :a, :e, :d]
      split = split_list(list)
      
      expect(split[0]).to eq([:a, :b, :c])
      expect(split[1]).to eq([:d, :e])
    end
    
    it "removes duplicates before splitting" do
      list = [:a, :b, :b, :c, :c, :d, :e, :e]
      split = split_list(list)
      
      expect(split[0]).to eq([:a, :b, :c])
      expect(split[1]).to eq([:d, :e])
    end
  end
end
