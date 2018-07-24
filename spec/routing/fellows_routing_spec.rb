require "rails_helper"

RSpec.describe Admin::FellowsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/fellows").to route_to("admin/fellows#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/fellows/new").to route_to("admin/fellows#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/fellows/1").to route_to("admin/fellows#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/fellows/1/edit").to route_to("admin/fellows#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/fellows").to route_to("admin/fellows#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/fellows/1").to route_to("admin/fellows#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/fellows/1").to route_to("admin/fellows#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/fellows/1").to route_to("admin/fellows#destroy", :id => "1")
    end

    it "routes to #upload" do
      expect(:get  => '/admin/fellows/upload').to route_to("admin/fellows#upload")
      expect(:post => '/admin/fellows/upload').to route_to("admin/fellows#upload")
    end
  end
end
