require "rails_helper"
require 'nokogiri'

RSpec.describe FellowMailer, type: :mailer do
  def self.skips_unsubscribed
    describe 'when user is unsubscribed from receiving opportunities' do
      let(:receive_opportunities) { false }

      it "does not send the mailer" do
        expect {
          mail.deliver
        }.to_not change(ActionMailer::Base.deliveries, :count) 
      end
    end
  end

  describe 'profile' do
    let(:access_token) { AccessToken.for(fellow) }

    let(:fellow) { create :fellow, receive_opportunities: receive_opportunities, contact: create(:contact, email: email) }
    let(:email) { 'test@example.com' }
    let(:receive_opportunities) { true }

    let(:mail) { FellowMailer.with(access_token: access_token).profile }
    
    it "renders the headers" do
      expect(mail.subject).to eq("Please Update Your Profile")
      expect(mail.to).to include(email)
      expect(mail.from).to include(Rails.application.secrets.mailer_from_email)
    end
    
    it "renders the body with interest links" do
      body = mail.body.encoded
      expect(body).to include("http://localhost:3011/fellows/#{fellow.id}/edit?token=#{access_token.code}")
    end
    
    skips_unsubscribed
  end
end
