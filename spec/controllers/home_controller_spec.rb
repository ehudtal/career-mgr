require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  render_views
  
  let(:user) { create :user }
  
  describe "GET #welcome" do
    before { sign_in user }

    describe 'when user is admin' do
      let(:user) { create :admin_user }

      it "routes to admin welcome page" do
        get :welcome
        expect(response).to redirect_to(admin_home_welcome_path)
      end
    end
    
    describe 'when user is fellow' do
      let(:user) { create :fellow_user }

      it "routes to fellow welcome page" do
        get :welcome
        expect(response).to redirect_to(fellow_home_welcome_path)
      end
    end
    
    describe 'when user role is undefined' do
      it "shows the default message" do
        get :welcome
        expect(response).to be_successful
      end
    end
  end
  
  describe 'GET login' do
    it "succeeds" do
      get :login
      expect(response).to be_successful
    end
  end
  
  describe 'GET health_check' do
    before { allow(User).to receive(:count) }
    
    it "checks the user count, to test the database" do
      expect(User).to receive(:count).once
      get :health_check
    end
    
    it "succeeds" do
      get :health_check
      expect(response).to be_successful
    end
    
    it "returns text message" do
      get :health_check
      expect(response.body).to eq("200 OK")
    end
  end
end
