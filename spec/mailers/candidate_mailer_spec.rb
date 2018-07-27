require "rails_helper"
require 'nokogiri'

RSpec.describe CandidateMailer, type: :mailer do
  let(:access_token) { AccessToken.for(fellow_opportunity) }

  let(:fellow_opportunity) { create :fellow_opportunity, fellow: fellow, opportunity: opportunity }
  let(:fellow) { create :fellow, contact: create(:contact, email: email) }
  let(:email) { 'test@example.com' }
  let(:opportunity) { create :opportunity, name: "New Opportunity" }

  let(:mail) { CandidateMailer.with(access_token: access_token).send(view) }
  
  class << self
    def expect_headers subject
      it { expect(mail.subject).to eq(subject) }
      it { expect(mail.to).to include(email) }
      it { expect(mail.from).to include(Rails.application.secrets.mailer_from_email) }
    end
    
    def expect_content content
      it "renders the body with content \"#{content}\"" do
        expect(mail.body.encoded).to include(content)
      end
    end
  
    def expect_status_link label
      it "renders body with status link \"#{label}\"" do
        expect(mail.body.encoded).to include("http://localhost:3011/candidates/#{fellow_opportunity.id}/status?update=#{label.gsub(' ', '+')}&token=#{access_token.code}")
      end
    end
  end
  
  describe 'invitation' do
    let(:view) { :invitation }
    
    expect_headers "You've been invited to apply for New Opportunity"
    expect_content 'New Opportunity'

    expect_status_link 'interested'
    expect_status_link 'not interested'
  end
  
  describe 'researched employer' do
    let(:view) { :researched_employer }
    
    expect_headers "New Opportunity: Research This Employer"
    expect_content 'Have you researched'
    
    expect_status_link 'researched employer'
    expect_status_link 'no change'
    expect_status_link 'skip'
    expect_status_link 'not interested'
  end

  describe 'connected with employees' do
    let(:view) { :connected_with_employees }
  
    expect_headers "New Opportunity: Connect with Current Employees"
    expect_content "Have you networked"

    expect_status_link 'connected with employees'
    expect_status_link 'no change'
    expect_status_link 'skip'
    expect_status_link 'not interested'
  end

  describe 'customized application materials' do
    let(:view) { :customized_application_materials }
  
    expect_headers "New Opportunity: Customized Your Application Materials"
    expect_content "Have you customized"

    expect_status_link 'customized application materials'
    expect_status_link 'no change'
    expect_status_link 'skip'
    expect_status_link 'not interested'
  end

  describe 'submitted application' do
    let(:view) { :submitted_application }
    
    expect_headers "New Opportunity: Submit Your Application"
    expect_content "Have you submitted"

    expect_status_link 'submitted application'
    expect_status_link 'no change'
    expect_status_link 'skip'
    expect_status_link 'not interested'
  end

  describe 'followed up after application submission' do
    let(:view) { :followed_up_after_application_submission }
    
    expect_headers "New Opportunity: Follow Up on Your Application"
    expect_content "Have you followed"

    expect_status_link 'followed up after application submission'
    expect_status_link 'no change'
    expect_status_link 'skip'
    expect_status_link 'not interested'
  end

  describe 'scheduled an interview' do
    let(:view) { :scheduled_an_interview }
    
    expect_headers "New Opportunity: Schedule an Interview"
    expect_content "Have you scheduled"

    expect_status_link 'scheduled an interview'
    expect_status_link 'no change'
    expect_status_link 'skip'
    expect_status_link 'not interested'
  end
end
