require_relative "../../rails_helper"

RSpec.describe Fellow::HomeController, type: :routing do
  describe "routing" do
    it "routes to #welcome via GET" do
      expect(:get => "fellow/home/welcome").to route_to("fellow/home#welcome")
    end

    it "routes to #career via POST" do
      expect(post: '/fellow/home/career').to route_to('fellow/home#career')
    end
  end
end
