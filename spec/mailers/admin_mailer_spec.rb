require "rails_helper"
require 'nokogiri'

RSpec.describe AdminMailer, type: :mailer do
  describe 'application submitted' do
    let(:fellow_opportunity) { create :fellow_opportunity, opportunity: opportunity, fellow: fellow }
    let(:fellow) { create :fellow }
    let(:opportunity) { create :opportunity, referral_email: referral_email }
    let(:referral_email) { 'test@example.com' }

    let(:mail) { AdminMailer.with(fellow_opportunity: fellow_opportunity).application_submitted }
    
    it "renders the headers" do
      expect(mail.subject).to eq("#{fellow.first_name} Submitted an Application")
      expect(mail.to).to include(referral_email)
      expect(mail.from).to include(Rails.application.secrets.mailer_from_email)
    end
    
    it "renders the body with opportunity link" do
      body = mail.body.encoded
      expect(body).to include("http://localhost:3011/admin/opportunities/#{opportunity.id}")
    end
  end
end
