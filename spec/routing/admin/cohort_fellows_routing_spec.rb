require_relative "../../rails_helper"

RSpec.describe Admin::CohortFellowsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/cohort_fellows").to route_to("admin/cohort_fellows#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/cohort_fellows/new").to route_to("admin/cohort_fellows#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/cohort_fellows/1").to route_to("admin/cohort_fellows#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/cohort_fellows/1/edit").to route_to("admin/cohort_fellows#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/cohort_fellows").to route_to("admin/cohort_fellows#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/cohort_fellows/1").to route_to("admin/cohort_fellows#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/cohort_fellows/1").to route_to("admin/cohort_fellows#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/cohort_fellows/1").to route_to("admin/cohort_fellows#destroy", :id => "1")
    end

  end
end
