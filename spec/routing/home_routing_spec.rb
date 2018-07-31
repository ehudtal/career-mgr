require "rails_helper"

RSpec.describe HomeController, type: :routing do
  describe "routing" do
    it "routes to #welcome via GET" do
      expect(:get => "/home/welcome").to route_to("home#welcome")
    end
    
    it "routes to #health_check via GET" do
      expect(:get => '/health_check').to route_to('home#health_check')
    end
  end
end
