require 'rails_helper'

RSpec.describe Admin::HomeController, type: :controller do
  render_views
  
  let(:user) { create :admin_user }
  
  before { sign_in user }
  
  describe 'when signed in user is not admin' do
    let(:user) { create :fellow_user }

    it "redirects GET #welcome to home" do
      get :welcome
      expect(response).to redirect_to(root_path)
    end

    it "redirects GET #new_opportunity to home" do
      get :new_opportunity
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #welcome" do
    it "returns http success" do
      get :welcome
      expect(response.status).to eq(200) #have_http_status(:success)
    end
  end

  describe "GET #new_opportunity" do
    it "returns http success" do
      get :new_opportunity
      expect(response.status).to eq(200) #have_http_status(:success)
    end
  end
end
