require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  render_views
  
  let(:user) { create :user }
  
  before { sign_in user }

  describe "GET #welcome" do
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
end
