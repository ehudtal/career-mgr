require "rails_helper"

RSpec.describe FellowsController, type: :routing do
  describe "routing" do
    let(:fellow_id) { '1001' }
    
    it "routes to #edit via GET" do
      expect(:get => "/fellows/#{fellow_id}/edit").to route_to("fellows#edit", id: fellow_id)
    end
    
    it "maps edit path" do
      expect(edit_fellow_path(fellow_id)).to eq("/fellows/#{fellow_id}/edit")
    end

    it "routes to #update via PUT" do
      expect(:put => "/fellows/#{fellow_id}").to route_to("fellows#update", id: fellow_id)
    end
    
    it "maps update path" do
      expect(fellow_path(fellow_id)).to eq("/fellows/#{fellow_id}")
    end
  end
end
