require "rails_helper"

RSpec.describe LocationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/employers/1/locations").to route_to("locations#index", employer_id: '1')
    end

    it "routes to #new" do
      expect(:get => "/employers/1/locations/new").to route_to("locations#new", employer_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/employers/1/locations/1").to route_to("locations#show", employer_id: '1', :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/employers/1/locations/1/edit").to route_to("locations#edit", employer_id: '1', :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/employers/1/locations").to route_to("locations#create", employer_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/employers/1/locations/1").to route_to("locations#update", employer_id: '1', :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/employers/1/locations/1").to route_to("locations#update", employer_id: '1', :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/employers/1/locations/1").to route_to("locations#destroy", employer_id: '1', :id => "1")
    end

  end
end
