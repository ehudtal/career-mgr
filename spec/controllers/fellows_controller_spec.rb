require 'rails_helper'

RSpec.describe FellowsController, type: :controller do
  render_views
  
  let(:fellow) { create :fellow, contact: create(:contact, email: email)}
  let(:email) { 'test@example.com' }
  
  let(:access_token) { create :access_token, code: code, routes: route_list }
  let(:code) { 'aaaabbbbccccdddd' }
  let(:route_list) { [route_edit, route_update] }
  let(:route_edit) { {'label' => 'Edit Your Profile', 'method' => 'GET', 'params' => {'controller' => 'fellows', 'action' => 'edit', 'id' => fellow.id.to_s}} }
  let(:route_update) { {'label' => 'Update Your Profile', 'method' => 'PUT', 'params' => {'controller' => 'fellows', 'action' => 'update', 'id' => fellow.id.to_s}} }

  let(:employment_status) { build :employment_status, id: 1001 }
  let(:industry) { create :industry }
  let(:interest) { create :interest }

  let(:valid_attributes) { attributes_for :fellow, employment_status_id: employment_status.id }
  let(:invalid_attributes) { {first_name: ''} }

  let(:valid_session) { {} }

  before do
    access_token; fellow
    allow_any_instance_of(Fellow).to receive(:employment_status).and_return(employment_status)
  end
  
  describe "GET #edit" do
    describe 'without token' do
      before { get :edit, params: {id: fellow.id} }
      
      it "redirects" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    
    it "returns http success" do
      get :edit, params: {id: fellow.id, token: code}
      expect(response).to be_successful
    end
  end

  describe "PUT #update" do
    describe 'without token' do
      before { put :update, params: {id: fellow.id, fellow: {}} }
      
      it "redirects" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with valid params" do
      let(:new_first_name) { valid_attributes[:first_name] + ' 2' }
      let(:new_attributes) { {first_name: new_first_name} }

      it "updates the requested fellow" do
        put :update, params: {id: fellow.to_param, token: code, fellow: new_attributes}, session: valid_session
        fellow.reload
      
        expect(fellow.first_name).to eq(new_first_name)
      end

      it "redirects to the fellow" do
        put :update, params: {id: fellow.to_param, token: code, fellow: valid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end

    it "associates specified industries with the fellow" do
      put :update, params: {id: fellow.to_param, token: code, fellow: valid_attributes.merge(industry_ids: [industry.id.to_s])}, session: valid_session
      fellow.reload
  
      expect(fellow.industries).to include(industry)
    end

    it "associates specified interests with the fellow" do
      put :update, params: {id: fellow.to_param, token: code, fellow: valid_attributes.merge(interest_ids: [interest.id.to_s])}, session: valid_session
      fellow.reload
  
      expect(fellow.interests).to include(interest)
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: fellow.to_param, token: code, fellow: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end
end
