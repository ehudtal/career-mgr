require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  let(:opportunity) { build :opportunity, id: '1001' }
  
  before { allow(Opportunity).to receive(:find).with(opportunity.id.to_s).and_return(opportunity) }
  
  describe "GET #index" do
    it "returns http success" do
      get :index, params: {opportunity_id: opportunity.id}
      expect(response).to be_successful
    end
  end

  describe "GET #create" do
    it "redirects to the opportunity path" do
      get :create, params: {opportunity_id: opportunity.id}
      expect(response).to redirect_to(opportunity_path(opportunity))
    end
  end

end
