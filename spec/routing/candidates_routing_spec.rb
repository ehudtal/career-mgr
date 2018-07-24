require "rails_helper"

RSpec.describe CandidatesController, type: :routing do
  describe "routing" do
    let(:fellow_opportunity_id) { '1001' }
    
    it "routes to #status" do
      expect(:get => "/candidates/#{fellow_opportunity_id}/status?update=Interested").to route_to("candidates#status", fellow_opportunity_id: fellow_opportunity_id, update: 'Interested')
    end
    
    it "routes to #status with token" do
      expect(:get => "/candidates/#{fellow_opportunity_id}/status?update=Interested&token=123").to route_to("candidates#status", fellow_opportunity_id: fellow_opportunity_id, update: 'Interested', token: '123')
    end
  end
end
