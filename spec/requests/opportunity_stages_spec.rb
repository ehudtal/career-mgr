require 'rails_helper'

RSpec.describe "OpportunityStages", type: :request do
  describe "GET /opportunity_stages" do
    it "works! (now write some real specs)" do
      get opportunity_stages_path
      expect(response).to have_http_status(200)
    end
  end
end
