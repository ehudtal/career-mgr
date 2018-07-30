require 'rails_helper'

RSpec.describe TokenController, type: :controller do
  let(:access_token) { create :access_token, code: code, routes: [route_one, route_two] }
  let(:code) { 'aaaabbbbccccdddd' }
  let(:route_one) { {'label' => 'one', 'method' => 'GET', 'params' => {'controller' => 'admin/industries', 'action' => 'list'}} }
  let(:route_two) { {'label' => 'two', 'method' => 'GET', 'params' => {'controller' => 'admin/interests', 'action' => 'list'}} }

  describe "GET #show" do
    describe 'token path' do
      it "creates the right path" do
        expect(token_path('1001')).to eq('/token/1001')
      end
    end
    
    describe 'when token is valid' do
      before { get :show, params: {id: access_token.code} }
      
      it "redirects to the first route" do
        expect(response).to redirect_to("http://localhost:3011/admin/industries/list?token=#{code}")
      end
    end
    
    describe 'when token is invalid' do
      before { get :show, params: {id: '1111111111111111'} }
      
      it "redirects to root path" do
        expect(response).to redirect_to(root_path)
      end
      
      it "sets the flash message" do
        expect(flash[:notice]).to include('expired')
      end
    end
  end
end
