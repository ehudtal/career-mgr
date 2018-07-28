require 'rails_helper'

RSpec.describe Fellow::OpportunitiesController, type: :controller do
  render_views
  
  let(:user) { create :fellow_user }
  let(:candidate) { create :fellow_opportunity, fellow: fellow, opportunity: opportunity}
  let(:fellow) { create :fellow, contact: create(:contact) }
  let(:opportunity) { create :opportunity }
  
  before do 
    user.fellow = fellow
    sign_in user
    
    candidate
  end

  let(:valid_attributes) { attributes_for :fellow }
  let(:invalid_attributes) { {name: ''} }
  let(:valid_session) { {} }

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: {id: candidate.id}, session: valid_session
      expect(response).to be_successful
    end
  end
  #
  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_last_name) { fellow.last_name + 'x' }
  #
  #     it "updates the requested industry" do
  #       put :update, params: {fellow: {last_name: new_last_name}}, session: valid_session
  #       fellow.reload
  #
  #       expect(fellow.last_name).to eq(new_last_name)
  #     end
  #
  #     it "redirects to the industries list" do
  #       put :update, params: {fellow: {last_name: new_last_name}}, session: valid_session
  #       expect(response).to redirect_to(fellow_profile_path)
  #     end
  #
  #     it "creates update notice message" do
  #       put :update, params: {fellow: {last_name: new_last_name}}, session: valid_session
  #       expect(flash[:notice]).to include('updated')
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "returns a success response (i.e. to display the 'edit' template)" do
  #       put :update, params: {fellow: {graduation_year: 4000}}, session: valid_session
  #       expect(response).to be_successful
  #     end
  #   end
  # end
end
