require_relative "../../rails_helper"

RSpec.describe TokenController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(:get => "/token/1001").to route_to("token#show", id: '1001')
    end
  end
end
