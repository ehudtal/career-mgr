require "rails_helper"

RSpec.describe OpportunitiesController, type: :routing do
  describe "routing" do
    require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
    
    it "routes to #index" do
      expect(:get => "/opportunities").to route_to("opportunities#index")
    end

    it "routes to #show" do
      expect(:get => "/opportunities/1").to route_to("opportunities#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/opportunities/1/edit").to route_to("opportunities#edit", :id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/opportunities/1").to route_to("opportunities#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/opportunities/1").to route_to("opportunities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/opportunities/1").to route_to("opportunities#destroy", :id => "1")
    end

    describe 'via employer' do
      let(:employer_id) { '1001' }

      it "routes to #index" do
        expect(:get => "/employers/#{employer_id}/opportunities").to route_to("opportunities#index", employer_id: employer_id)
      end

      it "routes to #new" do
        expect(:get => "/employers/#{employer_id}/opportunities/new").to route_to("opportunities#new", employer_id: employer_id)
      end

      it "routes to #create" do
        expect(:post => "/employers/#{employer_id}/opportunities").to route_to("opportunities#create", employer_id: employer_id)
      end
    end
  end
end
