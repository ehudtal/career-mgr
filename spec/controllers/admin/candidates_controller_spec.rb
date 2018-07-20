require 'rails_helper'

RSpec.describe Admin::CandidatesController, type: :controller do
  let(:opportunity) { build :opportunity, id: '1001' }
  
  before do
    allow(Opportunity).to receive(:find).with(opportunity.id.to_s).and_return(opportunity)
    allow_any_instance_of(FellowOpportunity).to receive(:opportunity).and_return(opportunity)
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

      expect(response).to redirect_to(admin_opportunity_path(opportunity))
    end
  end
  
  describe "PUT #update" do
    let(:initial_stage) { create :opportunity_stage, position: 0 }
    let(:next_stage) { create :opportunity_stage, position: 1 }
    
    let(:fellow) { create :fellow }
    let(:fellow_opportunity) { create :fellow_opportunity, fellow: fellow, opportunity: opportunity, opportunity_stage: initial_stage }

    it "updates the requested fellow-opp" do
      opportunity.save
      
      put :update, params: {id: fellow_opportunity.to_param, fellow_opportunity: {opportunity_stage_id: next_stage.id}}
      fellow_opportunity.reload
    
      expect(fellow_opportunity.opportunity_stage).to eq(next_stage)
    end
  end
  
  describe "DELETE #destroy" do
    let(:fellow) { create :fellow }
    let(:fellow_opportunity) { create :fellow_opportunity, fellow: fellow, opportunity: opportunity }

    before do
      opportunity.save; fellow_opportunity
    end
    
    it "soft-deletes the candidacy (fellow-opp)" do
      expect {
        delete :destroy, params: {id: fellow_opportunity.to_param}
      }.to change(FellowOpportunity, :count).by(-1)
    end
    
    it "redirects to the parent opportunity" do
      delete :destroy, params: {id: fellow_opportunity.to_param}
      expect(response).to redirect_to(admin_opportunity_url(opportunity))
    end
  end
end
