require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe Admin::IndustriesController, type: :controller do
  render_views
  
  let(:user) { create :admin_user }
  
  before { sign_in user }

  # This should return the minimal set of attributes required to create a valid
  # Industry. As you add validations to Industry, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { attributes_for :industry }
  let(:invalid_attributes) { {name: ''} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # IndustriesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'when signed-in user is not admin' do
    let(:user) { create :fellow_user }

    it "redirects GET #index to home" do
      get :index, params: {}, session: valid_session
      expect(response).to redirect_to(root_path)
    end

    describe 'GET #list' do
      it "returns successfully" do
        get :list, params: {}, session: valid_session
        expect(response).to be_successful
      end
    end
    
    it "redirects GET #show to home" do
      get :show, params: {id: '1001'}, session: valid_session
      expect(response).to redirect_to(root_path)
    end

    it "redirects GET #new to home" do
      get :new, params: {}, session: valid_session
      expect(response).to redirect_to(root_path)
    end
    
    it "redirects GET #edit to home" do
      get :edit, params: {id: '1001'}, session: valid_session
      expect(response).to redirect_to(root_path)
    end
    
    it "redirects POST #create to home" do
      post :create, params: {industry: valid_attributes}, session: valid_session
      expect(response).to redirect_to(root_path)
    end
    
    it "redirects PUT #update to home" do
      put :update, params: {id: '1001', industry: valid_attributes}, session: valid_session
      expect(response).to redirect_to(root_path)
    end
    
    it "redirects DELETE #destroy to home" do
      delete :destroy, params: {id: '1001'}, session: valid_session
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #index" do
    it "returns a success response" do
      industry = Industry.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #list' do
    it "returns successfully" do
      get :list, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      industry = Industry.create! valid_attributes
      get :show, params: {id: industry.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      industry = Industry.create! valid_attributes
      get :edit, params: {id: industry.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Industry" do
        expect {
          post :create, params: {industry: valid_attributes}, session: valid_session
        }.to change(Industry, :count).by(1)
      end

      it "redirects to the industries list" do
        post :create, params: {industry: valid_attributes}, session: valid_session
        expect(response).to redirect_to(admin_industries_path)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {industry: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_name) { valid_attributes[:name] + ' 2' }
      let(:new_attributes) { {name: new_name} }

      it "updates the requested industry" do
        industry = Industry.create! valid_attributes
        put :update, params: {id: industry.to_param, industry: new_attributes}, session: valid_session
        industry.reload
        
        expect(industry.name).to eq(new_name)
      end

      it "redirects to the industries list" do
        industry = Industry.create! valid_attributes
        put :update, params: {id: industry.to_param, industry: valid_attributes}, session: valid_session
        expect(response).to redirect_to(admin_industries_path)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        industry = Industry.create! valid_attributes
        put :update, params: {id: industry.to_param, industry: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested industry" do
      industry = Industry.create! valid_attributes
      expect {
        delete :destroy, params: {id: industry.to_param}, session: valid_session
      }.to change(Industry, :count).by(-1)
    end

    it "redirects to the industries list" do
      industry = Industry.create! valid_attributes
      delete :destroy, params: {id: industry.to_param}, session: valid_session
      expect(response).to redirect_to(admin_industries_url)
    end
  end
end
