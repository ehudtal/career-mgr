require "rails_helper"

RSpec.describe CandidatesController, type: :routing do
  describe "routing" do
    let(:opportunity_id) { '1001' }
    
    describe 'via opportunity' do
      it "routes to #index" do
        expect(:get => "/opportunities/#{opportunity_id}/candidates").to route_to("candidates#index", opportunity_id: opportunity_id)
      end

      it "routes to #create" do
        expect(:post => "/opportunities/#{opportunity_id}/candidates").to route_to("candidates#create", opportunity_id: opportunity_id)
      end
    end
  end
end
