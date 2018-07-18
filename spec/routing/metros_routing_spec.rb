require "rails_helper"

RSpec.describe MetrosController, type: :routing do
  describe "routing" do
    it "routes to #index.json" do
      expect(:get => "/metros.json").to route_to("metros#index", format: 'json')
    end

    it "routes to #list" do
      expect(:get => "/metros/list").to route_to("metros#list")
    end
  end
end
