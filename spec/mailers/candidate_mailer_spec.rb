require "rails_helper"
require 'nokogiri'

RSpec.describe CandidateMailer, type: :mailer do
  let(:access_token) { AccessToken.for(fellow_opportunity) }

  let(:fellow_opportunity) { create :fellow_opportunity, fellow: fellow, opportunity: opportunity, opportunity_stage: opportunity_stage }
  let(:fellow) { create :fellow, receive_opportunities: receive_opportunities, contact: create(:contact, email: email) }
  let(:email) { 'test@example.com' }
  let(:opportunity) { create :opportunity, name: "New Opportunity" }
  let(:opportunity_stage) { create :opportunity_stage, name: stage_name }
  let(:stage_name) { view.to_s.gsub('_', ' ') }
  let(:receive_opportunities) { true }

  let(:mail) { CandidateMailer.with(access_token: access_token, stage_name: stage_name).send(view) }
  
  class << self
    def expect_headers subject
      it { expect(mail.subject).to include(subject) }
      it { expect(mail.to).to include(email) }
      it { expect(mail.from).to include(Rails.application.secrets.mailer_from_email) }
      it_behaves_like 'unsubscribable'
    end
    
    def expect_content content
      it "renders the body with content \"#{content}\"" do
        expect(mail.body.encoded).to match(content)
      end
    end
  
    def expect_status_link from, label
      it "renders body with status link \"#{label}\"" do
        expect(mail.body.encoded).to include("http://localhost:3011/candidates/#{fellow_opportunity.id}/status?from=#{from.gsub(' ', '+')}&token=#{access_token.code}&update=#{label.gsub(' ', '+')}")
      end
    end
    
    def skips_unsubscribed
      describe 'when user is unsubscribed from receiving opportunities' do
        let(:receive_opportunities) { false }

        it "does not send the mailer" do
          expect {
            mail.deliver
          }.to_not change(ActionMailer::Base.deliveries, :count) 
        end
      end
    end
    
    def expect_bcc
      describe 'setting bcc' do
        before { allow(Rails.application.secrets).to receive(:mailer_bcc).and_return(mailer_bcc) }

        describe 'when mailer_bcc is nil' do
          let(:mailer_bcc) { nil }
          it { expect(mail.bcc).to be_nil }
        end
        
        describe 'when mailer_bcc is an e-mail' do
          let(:mailer_bcc) { 'test@example.com' }
          it { expect(mail.bcc).to include(mailer_bcc) }
        end
      end
    end
  end
  
  describe 'respond to invitation' do
    let(:stage_name) { 'respond to invitation' }
    
    let(:mail) { CandidateMailer.with(access_token: access_token).respond_to_invitation }

    expect_headers "New Opportunity"
    expect_content 'New Opportunity'
    expect_bcc

    expect_status_link 'respond to invitation', 'research employer'
    expect_status_link 'respond to invitation', 'fellow decline'
    
    skips_unsubscribed
  end
  
  describe 'via notify mailer' do
    let(:view) { :notify }
    let(:mail) { CandidateMailer.with(access_token: access_token, stage_name: stage_name).notify }

    describe 'research employer' do
      let(:stage_name) { 'research employer' }

      expect_headers "New Opportunity"
      expect_content 'Have you researched'
      expect_bcc

      expect_status_link 'research employer', 'next'
      expect_status_link 'research employer', 'no change'
      expect_status_link 'research employer', 'skip'
      expect_status_link 'research employer', 'fellow declined'
      
      skips_unsubscribed
    end

    describe 'connect with employees' do
      let(:stage_name) { 'connect with employees' }

      expect_headers "New Opportunity: Connect with Current Employees"
      expect_content "Have you networked"
      expect_bcc

      expect_status_link 'connect with employees', 'next'
      expect_status_link 'connect with employees', 'no change'
      expect_status_link 'connect with employees', 'skip'
      expect_status_link 'connect with employees', 'fellow declined'
      
      skips_unsubscribed
    end

    describe 'customize application materials' do
      let(:stage_name) { 'customize application materials' }

      expect_headers "New Opportunity: Customize Your Application Materials"
      expect_content "Have you customized"
      expect_bcc

      expect_status_link 'customize application materials', 'next'
      expect_status_link 'customize application materials', 'no change'
      expect_status_link 'customize application materials', 'skip'
      expect_status_link 'customize application materials', 'fellow declined'
      
      skips_unsubscribed
    end

    describe 'submit application' do
      let(:stage_name) { 'submit application' }

      expect_headers "New Opportunity: Submit Your Application"
      expect_content "Have you submitted"
      expect_bcc

      expect_status_link 'submit application', 'next'
      expect_status_link 'submit application', 'no change'
      expect_status_link 'submit application', 'skip'
      expect_status_link 'submit application', 'fellow declined'
      
      skips_unsubscribed
    end

    describe 'follow up after application' do
      let(:stage_name) { 'follow up after application' }

      expect_headers "New Opportunity: Follow Up on Your Application"
      expect_content "Have you followed"
      expect_bcc

      expect_status_link 'follow up after application', 'next'
      expect_status_link 'follow up after application', 'no change'
      expect_status_link 'follow up after application', 'skip'
      expect_status_link 'follow up after application', 'fellow declined'
      expect_status_link 'follow up after application', 'employer declined'
      
      skips_unsubscribed
    end

    describe 'schedule interview' do
      let(:stage_name) { 'schedule interview' }

      expect_headers "New Opportunity: Schedule an Interview"
      expect_content "Have you scheduled"
      expect_bcc

      expect_status_link 'schedule interview', 'next'
      expect_status_link 'schedule interview', 'no change'
      expect_status_link 'schedule interview', 'skip'
      expect_status_link 'schedule interview', 'fellow declined'
      expect_status_link 'schedule interview', 'employer declined'
      
      skips_unsubscribed
    end

    describe 'research interview process' do
      let(:stage_name) { 'research interview process' }

      expect_headers "New Opportunity"
      expect_content "Have you researched"
      expect_bcc

      expect_status_link 'research interview process', 'next'
      expect_status_link 'research interview process', 'no change'
      expect_status_link 'research interview process', 'skip'
      expect_status_link 'research interview process', 'fellow declined'
      
      skips_unsubscribed
    end

    describe 'practice for interview' do
      let(:stage_name) { 'practice for interview'}

      expect_headers "New Opportunity: Practice for Your Interview"
      expect_content "Have you practiced"
      expect_bcc

      expect_status_link 'practice for interview', 'next'
      expect_status_link 'practice for interview', 'no change'
      expect_status_link 'practice for interview', 'skip'
      expect_status_link 'practice for interview', 'fellow declined'
      
      skips_unsubscribed
    end

    describe 'attend interview' do
      let(:stage_name) { 'attend interview' }

      expect_headers "New Opportunity: Ace Your Interview!"
      expect_content "Have you attended"
      expect_bcc

      expect_status_link 'attend interview', 'next'
      expect_status_link 'attend interview', 'no change'
      expect_status_link 'attend interview', 'skip'
      expect_status_link 'attend interview', 'fellow declined'
      
      skips_unsubscribed
    end

    describe 'follow up after interview' do
      let(:stage_name) { 'follow up after interview' }

      expect_headers "New Opportunity: Follow Up After Your Interview"
      expect_content "Have you followed"
      expect_bcc

      expect_status_link 'follow up after interview', 'next'
      expect_status_link 'follow up after interview', 'no change'
      expect_status_link 'follow up after interview', 'skip'
      expect_status_link 'follow up after interview', 'fellow declined'
      expect_status_link 'follow up after interview', 'employer declined'
      
      skips_unsubscribed
    end

    describe 'receive offer' do
      let(:stage_name) { 'receive offer' }

      expect_headers "New Opportunity: Look out for an Offer"
      expect_content "Have you received"
      expect_bcc

      expect_status_link 'receive offer', 'next'
      expect_status_link 'receive offer', 'no change'
      expect_status_link 'receive offer', 'fellow declined'
      expect_status_link 'receive offer', 'employer declined'
      
      skips_unsubscribed
    end

    describe 'submit counter-offer' do
      let(:stage_name) { 'submit counter-offer' }

      expect_headers "New Opportunity: Consider making a Counter Offer"
      expect_content "Have you submitted"
      expect_bcc

      expect_status_link 'submit counter-offer', 'receive offer'
      expect_status_link 'submit counter-offer', 'no change'
      expect_status_link 'submit counter-offer', 'fellow accepted'
      expect_status_link 'submit counter-offer', 'fellow declined'
      
      skips_unsubscribed
    end

    describe 'accept offer' do
      let(:stage_name) { 'accept offer' }

      expect_headers "New Opportunity: Accept Your Offer!"
      expect_content "Have you accepted"
      expect_bcc

      expect_status_link 'accept offer', 'next'
      expect_status_link 'accept offer', 'no change'
      expect_status_link 'accept offer', 'fellow declined'
      
      skips_unsubscribed
    end
  end
end
