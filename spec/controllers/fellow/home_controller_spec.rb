require 'rails_helper'

RSpec.describe Fellow::HomeController, type: :controller do
  render_views
  
  let(:user) { create :fellow_user, fellow: fellow }
  let(:fellow) { create :fellow }
  
  before { sign_in user }
  
  describe 'when signed-in user is not a fellow' do
    let(:user) { create :user }
    
    it "redirects GET #welcome to home path" do
      get :welcome
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #welcome" do
    it "returns http success" do
      get :welcome
      expect(response.status).to eq(200) #have_http_status(:success)
    end
  end
  
  describe 'POST career' do
    it "updates career steps" do
      post :career, params: {career_steps: ['1', '3', '5']}
      expect(fellow.completed_career_steps).to eq([1,3,5])
    end
  end
end
