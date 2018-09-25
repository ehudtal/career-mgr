require_relative "../../rails_helper"

RSpec.describe Admin::MajorsController, type: :routing do
  describe "routing" do
    it "routes to #index.json" do
      expect(:get => "/admin/majors.json").to route_to("admin/majors#index", format: 'json')
    end

    it "routes to #list" do
      expect(:get => "/admin/majors/list").to route_to("admin/majors#list")
    end
  end
end
