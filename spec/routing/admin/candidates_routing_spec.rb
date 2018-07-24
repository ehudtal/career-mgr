require_relative "../../rails_helper"

RSpec.describe Admin::CandidatesController, type: :routing do
  describe "routing" do
    let(:opportunity_id) { '1001' }
    let(:candidate_id) { '1002' }
    
    describe 'via opportunity' do
      it "routes to #index" do
        expect(:get => "/admin/opportunities/#{opportunity_id}/candidates").to route_to("admin/candidates#index", opportunity_id: opportunity_id)
      end

      it "routes to #create" do
        expect(:post => "/admin/opportunities/#{opportunity_id}/candidates").to route_to("admin/candidates#create", opportunity_id: opportunity_id)
      end
    end
    
    it "routes to #update" do
      expect(:put => "/admin/candidates/#{candidate_id}").to route_to("admin/candidates#update", id: candidate_id)
    end
    
    it "routes to #destroy" do
      expect(:delete => "/admin/candidates/#{candidate_id}").to route_to("admin/candidates#destroy", id: candidate_id)
    end
  end
end
