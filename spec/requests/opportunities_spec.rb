require 'rails_helper'

RSpec.describe "Opportunities", type: :request do
  let(:employer) { build :employer, id: 1001 }
  
  before do
    allow(Employer).to receive(:find).with(employer.id.to_s).and_return(employer)
  end

  describe "GET /employers/1001/opportunities" do
    it "works" do
      get employer_opportunities_path(employer)
      expect(response).to have_http_status(200)
    end
  end
end
