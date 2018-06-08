require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:opportunity) { build :opportunity, id: 1001 }
  
  before { allow(Opportunity).to receive(:find).with('1001').and_return(opportunity) }
  
  describe "GET /opportunities/1001/tasks" do
    it "works" do
      get opportunity_tasks_path('1001')
      expect(response).to have_http_status(200)
    end
  end
end
