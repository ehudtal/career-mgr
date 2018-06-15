require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  let(:opportunity) { build :opportunity, id: '1001' }
  
  before do
    allow(Opportunity).to receive(:find).with(opportunity.id.to_s).and_return(opportunity)
  end  
  
  describe "GET #index" do
    it "returns http success" do
      get :index, params: {opportunity_id: opportunity.id}
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    it "creates the fellow_opportunity relationships" do
      expect(opportunity).to receive(:candidate_ids=).with(['1001'])
      
      post :create, params: {candidate_ids: ['1001'], opportunity_id: opportunity.id.to_s}

      expect(response).to redirect_to(opportunity_path(opportunity))
    end
  end
end
