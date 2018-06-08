require "rails_helper"

RSpec.describe TasksController, type: :routing do
  describe "routing" do

    describe 'nested under opportunities' do
      let(:opportunity_id) { '1001' }
      
      it "routes to #index" do
        expect(:get => "/opportunities/#{opportunity_id}/tasks").to route_to("tasks#index", opportunity_id: opportunity_id)
      end

      it "routes to #new" do
        expect(:get => "/opportunities/#{opportunity_id}/tasks/new").to route_to("tasks#new", opportunity_id: opportunity_id)
      end

      it "routes to #create" do
        expect(:post => "/opportunities/#{opportunity_id}/tasks").to route_to("tasks#create", opportunity_id: opportunity_id)
      end
    end

    it "routes to #show" do
      expect(:get => "/tasks/1").to route_to("tasks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/tasks/1/edit").to route_to("tasks#edit", :id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/tasks/1").to route_to("tasks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/tasks/1").to route_to("tasks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/tasks/1").to route_to("tasks#destroy", :id => "1")
    end

  end
end
