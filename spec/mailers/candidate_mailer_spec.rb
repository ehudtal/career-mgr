require "rails_helper"
require 'nokogiri'

RSpec.describe CandidateMailer, type: :mailer do
  let(:access_token) { AccessToken.for(fellow_opportunity) }

  let(:fellow_opportunity) { create :fellow_opportunity, fellow: fellow, opportunity: opportunity }
  let(:fellow) { create :fellow, contact: create(:contact, email: email) }
  let(:email) { 'test@example.com' }
  let(:opportunity) { create :opportunity, name: "New Opportunity" }

  let(:mail) { CandidateMailer.with(access_token: access_token).send(view) }
  
  describe 'invitation' do
    let(:view) { :invitation }
    
    it { expect(mail.subject).to eq("You've been invited to apply for New Opportunity") }
    it { expect(mail.to).to include(email) }
    it { expect(mail.from).to include(Rails.application.secrets.mailer_from_email) }

    it "renders the body with links" do
      body = mail.body.encoded
      
      expect(body).to include(opportunity.name)
      expect(body).to include("http://localhost:3011/candidates/#{fellow_opportunity.id}/status?update=Interested&token=#{access_token.code}")
      expect(body).to include("http://localhost:3011/candidates/#{fellow_opportunity.id}/status?update=Not+Interested&token=#{access_token.code}")
    end
  end

  describe 'applying' do
    let(:view) { :applying }
    
    it { expect(mail.subject).to eq("Are You Currently Applying for New Opportunity?") }
    it { expect(mail.to).to include(email) }
    it { expect(mail.from).to include(Rails.application.secrets.mailer_from_email) }

    it "renders the body with links" do
      body = mail.body.encoded
      
      expect(body).to include(opportunity.name)
      expect(body).to include("http://localhost:3011/candidates/#{fellow_opportunity.id}/status?update=Applying&token=#{access_token.code}")
      expect(body).to include("http://localhost:3011/candidates/#{fellow_opportunity.id}/status?update=Application+Submitted&token=#{access_token.code}")
      expect(body).to include("http://localhost:3011/candidates/#{fellow_opportunity.id}/status?update=Not+Interested&token=#{access_token.code}")
    end
  end
end
