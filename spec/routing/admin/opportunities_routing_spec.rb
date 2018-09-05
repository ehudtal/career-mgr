require_relative "../../rails_helper"

RSpec.describe Admin::OpportunitiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/opportunities").to route_to("admin/opportunities#index")
    end
    
    it "routes to #export" do
      expect(:post => '/admin/opportunities/export').to route_to('admin/opportunities#export')
    end

    it "routes to #show" do
      expect(:get => "/admin/opportunities/1").to route_to("admin/opportunities#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/opportunities/1/edit").to route_to("admin/opportunities#edit", :id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/opportunities/1").to route_to("admin/opportunities#update", :id => "1")
    end

    it "routes to #unpublish via PUT" do
      expect(:put => "/admin/opportunities/1/unpublish").to route_to("admin/opportunities#unpublish", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/opportunities/1").to route_to("admin/opportunities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/opportunities/1").to route_to("admin/opportunities#destroy", :id => "1")
    end

    describe 'via employer' do
      let(:employer_id) { '1001' }

      it "routes to #index" do
        expect(:get => "/admin/employers/#{employer_id}/opportunities").to route_to("admin/opportunities#index", employer_id: employer_id)
      end

      it "routes to #new" do
        expect(:get => "/admin/employers/#{employer_id}/opportunities/new").to route_to("admin/opportunities#new", employer_id: employer_id)
      end

      it "routes to #create" do
        expect(:post => "/admin/employers/#{employer_id}/opportunities").to route_to("admin/opportunities#create", employer_id: employer_id)
      end
    end
  end
end
