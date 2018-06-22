require "rails_helper"

RSpec.describe FellowsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/fellows").to route_to("fellows#index")
    end

    it "routes to #new" do
      expect(:get => "/fellows/new").to route_to("fellows#new")
    end

    it "routes to #show" do
      expect(:get => "/fellows/1").to route_to("fellows#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/fellows/1/edit").to route_to("fellows#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/fellows").to route_to("fellows#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/fellows/1").to route_to("fellows#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/fellows/1").to route_to("fellows#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/fellows/1").to route_to("fellows#destroy", :id => "1")
    end

    it "routes to #upload" do
      expect(:get  => '/fellows/upload').to route_to("fellows#upload")
      expect(:post => '/fellows/upload').to route_to("fellows#upload")
    end
  end
end
