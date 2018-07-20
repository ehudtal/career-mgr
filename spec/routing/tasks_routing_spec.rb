require "rails_helper"

RSpec.describe Admin::TasksController, type: :routing do
  describe "routing" do

    describe 'nested under opportunities' do
      let(:opportunity_id) { '1001' }
      
      it "routes to #index" do
        expect(:get => "/admin/opportunities/#{opportunity_id}/tasks").to route_to("admin/tasks#index", opportunity_id: opportunity_id)
      end

      it "routes to #new" do
        expect(:get => "/admin/opportunities/#{opportunity_id}/tasks/new").to route_to("admin/tasks#new", opportunity_id: opportunity_id)
      end

      it "routes to #create" do
        expect(:post => "/admin/opportunities/#{opportunity_id}/tasks").to route_to("admin/tasks#create", opportunity_id: opportunity_id)
      end
    end

    it "routes to #show" do
      expect(:get => "/admin/tasks/1").to route_to("admin/tasks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/tasks/1/edit").to route_to("admin/tasks#edit", :id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/tasks/1").to route_to("admin/tasks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/tasks/1").to route_to("admin/tasks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/tasks/1").to route_to("admin/tasks#destroy", :id => "1")
    end

  end
end
