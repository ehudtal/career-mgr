require 'rails_helper'

RSpec.describe "Courses", type: :request do
  let(:site) { build :site, id: 1001 }
  
  before { allow(Site).to receive(:find).with(site.id.to_s).and_return(site) }
  
  describe "GET /sites/1001/courses" do
    it "works! (now write some real specs)" do
      get site_courses_path(site.id.to_s)
      expect(response).to have_http_status(200)
    end
  end
end
