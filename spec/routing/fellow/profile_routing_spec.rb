require_relative "../../rails_helper"

RSpec.describe Fellow::ProfilesController, type: :routing do
  describe "routing" do

    it "routes to #show" do
      expect(:get => "/fellow/profile").to route_to("fellow/profiles#show")
    end

    it "routes to #edit" do
      expect(:get => "/fellow/profile/edit").to route_to("fellow/profiles#edit")
    end

    it "routes to #update via PUT" do
      expect(:put => "/fellow/profile").to route_to("fellow/profiles#update")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/fellow/profile").to route_to("fellow/profiles#update")
    end

    it "routes to #unsubscribe" do
      expect(:get => "/fellow/profile/unsubscribe").to route_to("fellow/profiles#unsubscribe")
    end
  end
end
