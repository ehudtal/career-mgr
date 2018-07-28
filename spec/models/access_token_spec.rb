require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  ##############
  # Associations
  ##############

  it { should belong_to :owner }
  
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
  
  describe 'setting expiration datetime' do
    let(:access_token) { build :access_token }
    
    it "sets expires_at to 30 days from now upon create" do
      access_token.save
      expect(access_token.expires_at).to be_within(0.1).of(30.days.from_now)
    end
    
    it "skips setting if expiration has already been set" do
      access_token.expires_at = 1.day.from_now
      access_token.save

      expect(access_token.expires_at).to be_within(0.1).of(1.day.from_now)
    end
  end
  
  ###############
  # Serialization
  ###############

  describe 'routes' do
    it "is stored as JSON" do
      access_token = create :access_token, routes: [{method: 'GET', path: '/test/this'}]
      access_token.reload
      
      expect(access_token.routes.first['method']).to eq('GET')
      expect(access_token.routes.first['path']).to eq('/test/this')
    end
  end
  
  ###############
  # Class methods
  ###############
  
  describe '::for(owner)' do
    subject { AccessToken.for(owner) }

    describe 'when owner is a fellow' do
      let(:owner) { create :fellow }

      it { should be_an(AccessToken) }
      it { should be_valid }
    
      it "is owned by the fellow" do
        expect(subject.owner).to eq(owner) 
      end
    
      it "has an array of routes" do
        expect(subject.routes).to be_an(Array)
        expect(subject.routes.size).to eq(3)
      end
    
      it "generates access token with dashboard view only" do
        expect(subject.routes).to include({'label' => 'view', 'method' => 'GET', 'path' => "http://localhost:3011/admin/fellows/#{owner.id}"})
      end
    
      it "generates token with edit route" do
        expect(subject.routes).to include({'label' => 'Edit Your Profile', 'method' => 'GET', 'path' => "http://localhost:3011/fellows/#{owner.id}/edit"})
      end
    
      it "generates token with update route" do
        expect(subject.routes).to include({'label' => 'Update Your Profile', 'method' => 'PUT', 'path' => "http://localhost:3011/fellows/#{owner.id}"})
      end
    end
    
    describe 'when owner is a fellow_opportunity' do
      let(:owner) { create :fellow_opportunity }
      
      it { should be_an(AccessToken) }
      it { should be_valid }
    
      it "is owned by the fellow_opportunity" do
        expect(subject.owner).to eq(owner) 
      end
    
      it "has an array of routes" do
        expect(subject.routes).to be_an(Array)
        expect(subject.routes.size).to eq(20)
      end

      allowed_statuses = [
        'no change', 'skip',
        'research employer', 'connect with employees', 'customize application materials', 'submit application', 'follow up after application',
        'schedule interview', 'research interview process', 'practice for interview', 'attend interview', 'follow up after interview',
        'receive offer', 'submit counter-offer', 'accept offer',
        'fellow accepted', 'fellow declined', 'employer declined'
      ]

      allowed_statuses.each do |status_update|
        it "allows route '#{status_update}'" do
          expect(subject.routes).to include({'label' => status_update, 'method' => 'GET', 'path' => "http://localhost:3011/candidates/#{owner.id}/status?update=#{status_update.gsub(' ', '+')}"})
        end
      end
      
      disallowed_statuses = ['respond to invitation']
      
      disallowed_statuses.each do |status_update|
        it "forbids route '#{status_update}'" do
          expect(subject.routes).to_not include({'label' => status_update, 'method' => 'GET', 'path' => "http://localhost:3011/candidates/#{owner.id}/status?update=#{status_update.gsub(' ', '+')}"})
        end
      end
      
      it "allows route for viewing fellow opportunity" do
        expect(subject.routes).to include({'label' => 'view', 'method' => 'GET', 'path' => "http://localhost:3011/fellow/opportunities/#{owner.id}"})
      end
      
      it "allows route for updating fellow opportunity" do
        expect(subject.routes).to include({'label' => 'update', 'method' => 'PUT', 'path' => "http://localhost:3011/fellow/opportunities/#{owner.id}"})
      end
    end
    
    describe 'when token already exists' do
      let(:owner) { create :fellow }
      let(:existing_token) { AccessToken.for(owner) }

      before { existing_token }
      
      it { should eq(existing_token) }
    end
    
    describe 'when there are no routes defined for owner type' do
      let(:owner) { User.new }
      
      it "returns an error" do
        expect{subject}.to raise_error("no token routes are defined for this object type.")
      end
    end
  end
  
  describe '::expire_tokens' do
    let(:token_old) { create :access_token, expires_at: 1.day.ago }
    let(:token_new) { create :access_token, expires_at: 1.day.from_now }
    
    before do
      token_old; token_new
      AccessToken.expire_tokens
    end
    
    it "removes tokens that are past their expiration date" do
      expect(AccessToken.find_by(id: token_old.id)).to be_nil
    end
    
    it "leaves tokens that haven't expired yet" do
      expect(AccessToken.find_by(id: token_new.id)).to eq(token_new)
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
    let(:route_get) { {'label' => 'get', 'method' => 'GET', 'path' => 'http://localhost:3011/get'} }
    let(:route_post) { {'label' => 'post', 'method' => 'POST', 'path' => 'http://localhost:3011/post'} }
    let(:route_put) { {'label' => 'put', 'method' => 'PUT', 'path' => 'http://localhost:3011/put'} }
    
    subject { build :access_token, code: code, routes: [route_get, route_post, route_put] }
    
    it "returns true if any route matches method AND path, minus token parameter" do
      request = double('request', params: {token: code}, original_url: "#{route_post['path']}?token=#{code}", request_method: 'POST')
      expect(subject.match?(request)).to be(true)
    end
    
    it "returns false if the token doesn't match" do
      request = double('request', params: {token: code+'x'}, original_url: "#{route_post['path']}?token=#{code}x", request_method: 'POST')
      expect(subject.match?(request)).to be(false)
    end
    
    it "returns false if request method doesn't match" do
      request = double('request', params: {token: code}, original_url: "#{route_post['path']}?token=#{code}", request_method: 'GET')
      expect(subject.match?(request)).to be(false)
    end
    
    it "returns false if original url (minus token) doesn't match" do
      request = double('request', params: {token: code}, original_url: "#{route_post['path']}x?token=#{code}", request_method: 'POST')
      expect(subject.match?(request)).to be(false)
    end
    
    it "returns true if request uses PATCH instead of PUT" do
      request = double('request', params: {token: code}, original_url: "#{route_put['path']}?token=#{code}", request_method: 'PATCH')
      expect(subject.match?(request)).to be(true)
    end
  end
  
  describe 'path_with_token(label)' do
    let(:access_token) { AccessToken.create code: code, routes: [route_one, route_two] }
    let(:code) { '0000000000000000' }
    let(:route_one) { {'label' => 'one', 'method' => 'GET', 'path' => '/test/one'} }
    let(:route_two) { {'label' => 'two', 'method' => 'POST', 'path' => '/test/two'} }
    
    it "returns the path WITH token param" do
      expect(access_token.path_with_token('two')).to eq("/test/two?token=#{code}")
    end
    
    it "returns the default path with token param" do
      expect(access_token.path_with_token).to eq("/test/one?token=#{code}")
    end
  end
end
