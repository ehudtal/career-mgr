require 'rails_helper'

RSpec.describe "Cohorts", type: :request do
  describe "GET /cohorts" do
    it "works! (now write some real specs)" do
      get cohorts_path
      expect(response).to have_http_status(200)
    end
  end
end
