require_relative "../../rails_helper"

RSpec.describe Admin::EmploymentStatusesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/employment_statuses").to route_to("admin/employment_statuses#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/employment_statuses/new").to route_to("admin/employment_statuses#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/employment_statuses/1").to route_to("admin/employment_statuses#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/employment_statuses/1/edit").to route_to("admin/employment_statuses#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/employment_statuses").to route_to("admin/employment_statuses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/employment_statuses/1").to route_to("admin/employment_statuses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/employment_statuses/1").to route_to("admin/employment_statuses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/employment_statuses/1").to route_to("admin/employment_statuses#destroy", :id => "1")
    end

  end
end
