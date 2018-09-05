require_relative "../../rails_helper"

RSpec.describe Admin::MetrosController, type: :routing do
  describe "routing" do
    it "routes to #index.json" do
      expect(:get => "/admin/metros.json").to route_to("admin/metros#index", format: 'json')
    end

    it "routes to #list" do
      expect(:get => "/admin/metros/list").to route_to("admin/metros#list")
    end

    it "routes to #search" do
      expect(:get => "/admin/metros/search").to route_to("admin/metros#search")
    end
  end
end
