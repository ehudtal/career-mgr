require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  render_views

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
