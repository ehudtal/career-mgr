require 'rails_helper'

RSpec.describe Admin::HomeController, type: :controller do
  render_views
  
  let(:user) { create :user }
  
  before { sign_in user }

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
