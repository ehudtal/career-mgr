require 'rails_helper'

RSpec.describe "FellowOpportunities", type: :request do
  describe "GET /fellow_opportunities" do
    it "works! (now write some real specs)" do
      get fellow_opportunities_path
      expect(response).to have_http_status(200)
    end
  end
end
