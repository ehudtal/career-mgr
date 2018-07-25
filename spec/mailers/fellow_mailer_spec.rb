require "rails_helper"
require 'nokogiri'

RSpec.describe FellowMailer, type: :mailer do
  describe 'profile' do
    let(:access_token) { AccessToken.update_profile(fellow) }

    let(:fellow) { create :fellow, contact: create(:contact, email: email) }
    let(:email) { 'test@example.com' }

    let(:mail) { FellowMailer.with(access_token: access_token, fellow: fellow).profile }
    
    it "renders the headers" do
      expect(mail.subject).to eq("Please Update Your Profile")
      expect(mail.to).to include(email)
      expect(mail.from).to include(Rails.application.secrets.mailer_from_email)
    end
    
    it "renders the body with interest links" do
      body = mail.body.encoded
      expect(body).to include("http://localhost:3011/fellows/#{fellow.id}/edit?token=#{access_token.code}")
    end
  end
end
