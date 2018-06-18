require "rails_helper"

RSpec.describe CoursesController, type: :routing do
  describe "routing" do
    let(:site_id) { '1001' }
    
    describe 'via site' do
      it "routes to #new" do
        expect(:get => "/sites/#{site_id}/courses/new").to route_to("courses#new", site_id: site_id)
      end

      it "routes to #create" do
        expect(:post => "/sites/#{site_id}/courses").to route_to("courses#create", site_id: site_id)
      end
    end

    it "routes to #show" do
      expect(:get => "/courses/1").to route_to("courses#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/courses/1/edit").to route_to("courses#edit", :id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/courses/1").to route_to("courses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/courses/1").to route_to("courses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/courses/1").to route_to("courses#destroy", :id => "1")
    end
  end
end
