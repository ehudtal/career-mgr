require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  #############
  # Validations
  #############
  
  # validating the code attribute requires disabling :generate_token, which always results in a valid code.

  describe 'validating presence' do
    before { allow_any_instance_of(AccessToken).to receive(:generate_token).and_return(nil) }
    it { should validate_presence_of :code }
  end
  
  describe 'validating uniqueness' do
    before do
      allow_any_instance_of(AccessToken).to receive(:generate_token).and_return(nil)
      create :access_token, code: '11112222aaaabbbb'
    end
    
    it { should validate_uniqueness_of :code }
  end
  
  describe 'validating routes' do
    let(:access_token) { build :access_token, routes: routes }
    let(:error_message) { access_token.send(:invalid_routes_message) }
    
    before { access_token.valid? }
    
    subject { access_token.errors[:routes] }
    
    describe "when an array of hashes, with keys 'method' and 'path'" do
      let(:routes) { [{'method' => 'GET', 'path' => '/this/path'}] }
      it { should be_empty }
    end
    
    describe 'when not an array' do
      let(:routes) { {test: 'this'} }
      it { should include(error_message) }
    end
    
    describe 'when array is empty' do
      let(:routes) { [] }
      it { should include("requires at least one route") }
    end
    
    describe 'when not an array of hashes' do
      let(:routes) { ['test', 'this'] }
      it { should include(error_message) }
    end
    
    describe 'when not all hashes have method key' do
      let(:routes) { [{'method' => 'GET', 'path' => '/test/this'}, {'path' => '/get/another'}] }
      it { should include(error_message) }
    end
    
    describe 'when not all hashes have path key' do
      let(:routes) { [{'method' => 'GET', 'path' => '/test/this'}, {'method' => 'POST'}] }
      it { should include(error_message) }
    end
  end

  ###########
  # Callbacks
  ###########

  describe 'generating code' do
    let(:access_token) { build :access_token}
    
    it "generates code upon create" do
      access_token.save
      expect(access_token.code).to match(/^[0-9a-f]{16}$/)
    end
    
    it "generates new code when old code is invalid" do
      access_token.code = '123'
      access_token.save
      
      expect(access_token.reload.code).to match(/^[0-9a-f]{16}$/)
    end
    
    describe 'when generated code is already taken' do
      let(:first_code) { '0000000000000000' }
      let(:second_code) { '1111111111111111' }
      
      before do
        create :access_token, code: first_code
        allow(access_token).to receive(:random_token).and_return(first_code, second_code)
      end
      
      it "tries new codes until it finds something unique" do
        access_token.save
        expect(access_token.code).to eq(second_code)
      end
    end
  end
  
  ###############
  # Serialization
  ###############

  describe 'routes' do
    it "is stored as JSON" do
      access_token = AccessToken.create routes: [{method: 'GET', path: '/test/this'}]
      access_token.reload
      
      expect(access_token.routes.first['method']).to eq('GET')
      expect(access_token.routes.first['path']).to eq('/test/this')
    end
  end
  
  ###############
  # Class methods
  ###############

  describe '::fellow_dashboard_view(fellow)' do
    let(:fellow) { create :fellow }
    subject { AccessToken.fellow_dashboard_view(fellow) }
    
    it "generates access token with dashboard view only" do
      expect(subject).to be_an(AccessToken)
      expect(subject.routes).to eq([{'label' => 'view', 'method' => 'GET', 'path' => "http://localhost:3011/admin/fellows/#{fellow.id}"}])
    end
  end
  
  ##################
  # Instance methods
  ##################

  describe 'route_for(label)' do
    let(:route_one) { {'label' => 'one', 'method' => 'GET', 'path' => '/test/one'} }
    let(:route_two) { {'label' => 'two', 'method' => 'POST', 'path' => '/test/two'} }
    
    let(:access_token) { AccessToken.create routes: [route_one, route_two] }
    
    it "provides the requested route by label" do
      expect(access_token.route_for('two')).to eq(route_two)
    end
    
    it "provides first route by default" do
      expect(access_token.route_for()).to eq(route_one)
    end

    it "provides first route when nil is specified" do
      expect(access_token.route_for(nil)).to eq(route_one)
    end
  end
  
  describe 'match?(request)' do
    let(:code) { 'aaaabbbbccccdddd' }
    let(:route_first) { {'label' => 'first', 'method' => 'GET', 'path' => 'http://localhost:3011/first'} }
    let(:route_second) { {'label' => 'second', 'method' => 'POST', 'path' => 'http://localhost:3011/second'} }
    
    subject { build :access_token, code: code, routes: [route_first, route_second] }
    
    it "returns true if any route matches method AND path, minus token parameter" do
      request = double('request', original_url: "http://localhost:3011/second?token=#{code}", request_method: 'POST')
      expect(subject.match?(request)).to be(true)
    end
    
    it "returns false if the token doesn't match" do
      request = double('request', original_url: "http://localhost:3011/second?token=#{code}x", request_method: 'POST')
      expect(subject.match?(request)).to be(false)
    end
    
    it "returns false if request method doesn't match" do
      request = double('request', original_url: "http://localhost:3011/second?token=#{code}", request_method: 'GET')
      expect(subject.match?(request)).to be(false)
    end
    
    it "returns false if original url (minus token) doesn't match" do
      request = double('request', original_url: "http://localhoster:3011/second?token=#{code}", request_method: 'POST')
      expect(subject.match?(request)).to be(false)
    end
  end
end
