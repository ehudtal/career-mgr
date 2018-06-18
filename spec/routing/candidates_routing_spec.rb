require "rails_helper"

RSpec.describe CandidatesController, type: :routing do
  describe "routing" do
    let(:opportunity_id) { '1001' }
    let(:candidate_id) { '1002' }
    
    describe 'via opportunity' do
      it "routes to #index" do
        expect(:get => "/opportunities/#{opportunity_id}/candidates").to route_to("candidates#index", opportunity_id: opportunity_id)
      end

      it "routes to #create" do
        expect(:post => "/opportunities/#{opportunity_id}/candidates").to route_to("candidates#create", opportunity_id: opportunity_id)
      end
    end
    
    it "routes to #update" do
      expect(:put => "/candidates/#{candidate_id}").to route_to("candidates#update", id: candidate_id)
    end
    
    it "routes to #destroy" do
      expect(:delete => "/candidates/#{candidate_id}").to route_to("candidates#destroy", id: candidate_id)
    end
  end
end
