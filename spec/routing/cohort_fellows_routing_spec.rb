require "rails_helper"

RSpec.describe CohortFellowsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/cohort_fellows").to route_to("cohort_fellows#index")
    end

    it "routes to #new" do
      expect(:get => "/cohort_fellows/new").to route_to("cohort_fellows#new")
    end

    it "routes to #show" do
      expect(:get => "/cohort_fellows/1").to route_to("cohort_fellows#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/cohort_fellows/1/edit").to route_to("cohort_fellows#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/cohort_fellows").to route_to("cohort_fellows#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/cohort_fellows/1").to route_to("cohort_fellows#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/cohort_fellows/1").to route_to("cohort_fellows#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/cohort_fellows/1").to route_to("cohort_fellows#destroy", :id => "1")
    end

  end
end
