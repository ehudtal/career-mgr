require "rails_helper"

RSpec.describe HomeController, type: :routing do
  describe "routing" do
    it "routes to #welcome via GET" do
      expect(:get => "/home/welcome").to route_to("home#welcome")
    end
    
    it "routes to #login via GET" do
      expect(:get => '/login').to route_to('home#login')
    end
    
    it "routes to #sso via GET" do
      expect(:get => '/sso/braven').to route_to('home#sso', id: 'braven')
    end
    
    it "routes to #health_check via GET" do
      expect(:get => '/health_check').to route_to('home#health_check')
    end
  end
end
