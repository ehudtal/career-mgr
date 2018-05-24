require 'rails_helper'

RSpec.describe "CohortFellows", type: :request do
  describe "GET /cohort_fellows" do
    it "works! (now write some real specs)" do
      get cohort_fellows_path
      expect(response).to have_http_status(200)
    end
  end
end
