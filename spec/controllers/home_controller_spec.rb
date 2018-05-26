require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #welcome" do
    it "returns http success" do
      get :welcome
      expect(response.status).to eq(200) #have_http_status(:success)
    end
  end

end
