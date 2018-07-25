require_relative "../../rails_helper"

RSpec.describe Admin::IndustriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/industries").to route_to("admin/industries#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/industries/new").to route_to("admin/industries#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/industries/1").to route_to("admin/industries#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/industries/1/edit").to route_to("admin/industries#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/industries").to route_to("admin/industries#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/industries/1").to route_to("admin/industries#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/industries/1").to route_to("admin/industries#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/industries/1").to route_to("admin/industries#destroy", :id => "1")
    end

    it "routes to #list" do
      expect(:get => '/admin/industries/list').to route_to("admin/industries#list")
    end

    it "routes to #combined" do
      expect(:get => '/admin/industries/combined').to route_to("admin/industries#combined")
    end
  end
end
