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
  
  describe 'link_to_unsubscribe' do
    let(:fellow) { create :fellow }
    let(:access_token) { AccessToken.for(fellow) }
    
    it "links to unsubscribe" do
      access_token
      expect(link_to_unsubscribe(fellow)).to eq(link_to('Unsubscribe', "http://localhost:3011/fellow/profile/unsubscribe?token=#{access_token.code}".html_safe))
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
  
  describe '#nearest_distance(fellow, postal_codes)' do
    let(:postal_codes) { ['12345', '23456'] }
    let(:fellow) { build :fellow }
    
    before do
      allow(fellow).to receive(:nearest_distance).with(postal_codes).and_return(distance)
    end
    
    subject { nearest_distance(fellow, postal_codes) }

    describe 'when a nearest distance is zero' do
      let(:distance) { 0 }
      it { should eq("0 miles") }
    end
    
    describe 'when a nearest distance is singular' do
      let(:distance) { 1 }
      it { should eq("1 mile") }
    end
    
    describe 'when a nearest distance is plural' do
      let(:distance) { 2 }
      it { should eq("2 miles") }
    end
    
    describe 'when no nearest distance is returned' do
      let(:distance) { nil }
      it { should eq("N/A") }
    end
  end
  
  describe '#checkmark(boolean)' do
    subject { checkmark(boolean) }
    
    describe 'when boolean is true' do
      let(:boolean) { true }
      it { should eq('&#x2714;'.html_safe) }
    end
    
    describe 'when boolean is false' do
      let(:boolean) { false }
      it { should be_blank }
    end
  end
  
  describe '#paragraph_format(text)' do
    subject { paragraph_format(text) }
    
    describe 'when text has only one paragraph' do
      let(:text) { 'This is short text.' }

      it { should eq("<p>This is short text.</p>") }
      it { should be_html_safe }
    end
    
    describe 'when text has newlines' do
      let(:text) { "Test\nTest\n\nTest" }

      it { should eq("<p>Test</p><p>Test</p><p>Test</p>") }
      it { should be_html_safe }
    end
    
    describe 'when text uses carriage returns as well as newlines' do
      let(:text) { "Test\r\nTest\r\n\r\nTest" }

      it { should eq("<p>Test</p><p>Test</p><p>Test</p>") }
      it { should be_html_safe }
    end
  end
  
  describe '#date_format(date)' do
    subject { date_format(date) }
    
    describe 'when date is valid' do
      let(:date) { Date.parse('1977-04-09') }
      it { should eq('Apr 9, 1977') }
    end
    
    describe 'when date is nil' do
      let(:date) { nil }
      it { should eq('') }
    end
  end
  
  describe '#address_parts(contact)' do
    let(:contact) { build :contact, address_1: address_1, address_2: address_2, city: city, state: state, postal_code: postal_code }
    
    let(:address_1) { '123 Way Street' }
    let(:address_2) { 'Apt #A' }
    let(:city) { 'Lincoln' }
    let(:state) { 'NE' }
    let(:postal_code) { '68521' }
    
    subject { address_parts(contact) }
    
    describe 'when all parts of the address exist' do
      it { should be_an(Array) }
      it { expect(subject.size).to eq(3) }
      
      it { should include('123 Way Street') }
      it { should include('Apt #A') }
      it { should include('Lincoln, NE 68521') }
    end
    
    describe 'when there is no address_2' do
      let(:address_2) { nil }
      
      it { should be_an(Array) }
      it { expect(subject.size).to eq(2) }
      
      it { should include('123 Way Street') }
      it { should include('Lincoln, NE 68521') }
    end
    
    describe 'when there is no city' do
      let(:city) { nil }
      
      it { should be_an(Array) }
      it { expect(subject.size).to eq(3) }
      
      it { should include('123 Way Street') }
      it { should include('Apt #A') }
      it { should include('NE 68521') }
    end
    
    describe 'when there is no state' do
      let(:state) { nil }
      
      it { should be_an(Array) }
      it { expect(subject.size).to eq(3) }
      
      it { should include('123 Way Street') }
      it { should include('Apt #A') }
      it { should include('Lincoln 68521') }
    end
    
    describe 'when there is no city or state' do
      let(:city) { nil }
      let(:state) { nil }
      
      it { should be_an(Array) }
      it { expect(subject.size).to eq(3) }
      
      it { should include('123 Way Street') }
      it { should include('Apt #A') }
      it { should include('68521') }
    end
    
    describe 'when there is no postal code' do
      let(:postal_code) { nil }
      
      it { should be_an(Array) }
      it { expect(subject.size).to eq(3) }
      
      it { should include('123 Way Street') }
      it { should include('Apt #A') }
      it { should include('Lincoln, NE') }
    end
    
    describe 'when there is no city, state, postal_code' do
      let(:city) { nil }
      let(:state) { nil }
      let(:postal_code) { nil }
      
      it { should be_an(Array) }
      it { expect(subject.size).to eq(2) }
      
      it { should include('123 Way Street') }
      it { should include('Apt #A') }
    end
  end
  
  describe '#address_for(contact)' do
    let(:contact) { build :contact }
    
    before { allow_any_instance_of(ApplicationHelper).to receive(:address_parts).with(contact).and_return(['a', 'b', 'c'])}
    
    subject { address_for(contact) }
    
    it { should eq("a<br>b<br>c") }
    it { should be_html_safe }
  end
end
