require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  render_views
  
  let(:user) { create :"#{role}_user" }
  
  before { sign_in user }

  describe "GET #welcome" do
    describe 'when user is admin' do
      let(:role) { :admin }

      it "routes to admin welcome page" do
        get :welcome
        expect(response).to redirect_to(admin_home_welcome_path)
      end
    end
  end
end
