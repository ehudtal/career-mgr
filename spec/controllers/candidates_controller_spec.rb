require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  let(:opportunity_stage) { create :opportunity_stage, name: 'Interested' }
  
  let(:access_token) { create :access_token, code: code, routes: route_list }
  let(:code) { 'aaaabbbbccccdddd' }
  let(:route_list) { [route_interested, route_not_interested, route_bad_id] }
  let(:route_interested) { {'label' => 'Interested', 'method' => 'GET', 'path' => candidate_status_url(fellow_opportunity.id, update: 'Interested')} }
  let(:route_not_interested) { {'label' => 'Not Interested', 'method' => 'GET', 'path' => candidate_status_url(fellow_opportunity.id, update: 'Not Interested')} }
  let(:route_bad_id) { {'label' => 'Interested', 'method' => 'GET', 'path' => candidate_status_url(fellow_opportunity.id, update: 'Interested')} }
  
  
  let(:fellow_opportunity) { create :fellow_opportunity, fellow: fellow, opportunity: opportunity }
  let(:fellow) { create :fellow }
  let(:opportunity) { create :opportunity }
  
  before do
    opportunity_stage; access_token; fellow_opportunity
  end
  
  describe "GET #status" do
    it "redirects without token" do
      get :status, params: {fellow_opportunity_id: fellow_opportunity.id, update: 'Interested'}

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to include('The link you requested is unavailable')
    end
    
    it "redirects with bad token" do
      get :status, params: {fellow_opportunity_id: fellow_opportunity.id, update: 'Interested', token: 'badtoken'}

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to include('The link you requested is unavailable')
    end
    
    it "redirects with bad fellow_opp id" do
      get :status, params: {fellow_opportunity_id: '1001', update: 'Interested', token: access_token.code}
      
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to include('The link you requested is unavailable')
    end
    
    it "returns http success" do
      get :status, params: {fellow_opportunity_id: fellow_opportunity.id, update: 'Interested', token: access_token.code}
      expect(response).to be_successful
    end
    
    it "updates the fellow_opportunity stage" do
      get :status, params: {fellow_opportunity_id: fellow_opportunity.id, update: 'Interested', token: access_token.code}
      expect(fellow_opportunity.reload.stage).to eq('Interested')
    end
  end
end
