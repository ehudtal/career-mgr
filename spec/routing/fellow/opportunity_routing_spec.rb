require_relative "../../rails_helper"

RSpec.describe Fellow::OpportunitiesController, type: :routing do
  describe "routing" do
    let(:opportunity_id) { '1001' }

    it "routes to #show" do
      expect(:get => "/fellow/opportunities/#{opportunity_id}").to route_to("fellow/opportunities#show", id: opportunity_id)
    end

    it "routes to #update via PUT" do
      expect(:put => "/fellow/opportunities/#{opportunity_id}").to route_to("fellow/opportunities#update", id: opportunity_id)
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/fellow/opportunities/#{opportunity_id}").to route_to("fellow/opportunities#update", id: opportunity_id)
    end
  end
end
