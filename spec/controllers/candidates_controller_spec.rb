require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  let(:previous_stage) { create :opportunity_stage, name: 'offered' }
  let(:opportunity_stage) { create :opportunity_stage, name: 'accepted', active_status: active_status }
  let(:active_status) { true }
  
  let(:access_token) { create :access_token, code: code, routes: route_list }
  let(:code) { 'aaaabbbbccccdddd' }
  let(:route_list) { [{'label' => 'status', 'method' => 'GET', 'params' => {'controller' => 'candidates', 'action' => 'status', 'fellow_opportunity_id' => fellow_opportunity.id.to_s, 'update' => /^(submitted|accepted|declined)$/}}] }
  
  let(:fellow_opportunity) { create :fellow_opportunity, fellow: fellow, opportunity: opportunity, opportunity_stage: previous_stage }
  let(:fellow) { create :fellow }
  let(:opportunity) { create :opportunity }
  
  before do
    opportunity_stage; access_token; fellow_opportunity
  end
  
  describe "GET #status" do
    before do
      allow_any_instance_of(OpportunityStage).to receive(:content).and_return({'notices' => {'accepted' => 'Congrats!'}})
    end 
    
    it "redirects without token" do
      get :status, params: {fellow_opportunity_id: fellow_opportunity.id, update: 'accepted'}

      expect(response).to redirect_to(new_user_session_path)
    end
    
    it "redirects with bad token" do
      get :status, params: {fellow_opportunity_id: fellow_opportunity.id, update: 'accepted', token: 'badtoken'}

      expect(response).to redirect_to(new_user_session_path)
    end
    
    it "redirects with bad fellow_opp id" do
      get :status, params: {fellow_opportunity_id: '1001', update: 'accepted', token: access_token.code}
      
      expect(response).to redirect_to(new_user_session_path)
    end
    
    describe 'when new stage is an "active" one' do
      let(:active_status) { true }
    
      it "redirects to this opportunity" do
        get :status, params: {fellow_opportunity_id: fellow_opportunity.id, update: 'accepted', token: access_token.code}
        expect(response).to redirect_to(fellow_opportunity_path(fellow_opportunity))
      end
    end
    
    describe 'when new stage is an "inactive" one' do
      let(:active_status) { false }
    
      it "redirects to fellow's home page" do
        get :status, params: {fellow_opportunity_id: fellow_opportunity.id, update: 'accepted', token: access_token.code}
        expect(response).to redirect_to(root_path)
      end
    end
    
    it "updates the fellow_opportunity stage" do
      get :status, params: {fellow_opportunity_id: fellow_opportunity.id, update: 'accepted', token: access_token.code}
      expect(fellow_opportunity.reload.stage).to eq('accepted')
    end
    
    it "sets the flash notice" do
      get :status, params: {fellow_opportunity_id: fellow_opportunity.id, update: 'accepted', token: access_token.code}
      expect(flash[:stage_notice]).to eq('Congrats!')
    end
    
    it "completes any a/b tests" do
      expect(controller).to receive(:split_test_complete).once
      get :status, params: {fellow_opportunity_id: fellow_opportunity.id, update: 'accepted', token: access_token.code}
    end
  end
end
