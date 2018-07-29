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
        expect(mail.body.encoded).to match(content)
      end
    end
  
    def expect_status_link from, label
      it "renders body with status link \"#{label}\"" do
        expect(mail.body.encoded).to include("http://localhost:3011/candidates/#{fellow_opportunity.id}/status?from=#{from.gsub(' ', '+')}&token=#{access_token.code}&update=#{label.gsub(' ', '+')}")
      end
    end
  end
  
  describe 'respond to invitation' do
    let(:view) { :respond_to_invitation }
    
    expect_headers "You've been invited to apply for New Opportunity"
    expect_content 'New Opportunity'

    expect_status_link 'respond to invitation', 'research employer'
    expect_status_link 'respond to invitation', 'fellow decline'
  end

  describe 'research employer' do
    let(:view) { :research_employer }

    expect_headers "New Opportunity: Research This Employer"
    expect_content 'Have you researched'

    expect_status_link 'research employer', 'next'
    expect_status_link 'research employer', 'no change'
    expect_status_link 'research employer', 'skip'
    expect_status_link 'research employer', 'fellow declined'
  end

  describe 'connect with employees' do
    let(:view) { :connect_with_employees }

    expect_headers "New Opportunity: Connect with Current Employees"
    expect_content "Have you networked"

    expect_status_link 'connect with employees', 'next'
    expect_status_link 'connect with employees', 'no change'
    expect_status_link 'connect with employees', 'skip'
    expect_status_link 'connect with employees', 'fellow declined'
  end

  describe 'customize application materials' do
    let(:view) { :customize_application_materials }

    expect_headers "New Opportunity: Customize Your Application Materials"
    expect_content "Have you customized"

    expect_status_link 'customize application materials', 'next'
    expect_status_link 'customize application materials', 'no change'
    expect_status_link 'customize application materials', 'skip'
    expect_status_link 'customize application materials', 'fellow declined'
  end

  describe 'submit application' do
    let(:view) { :submit_application }

    expect_headers "New Opportunity: Submit Your Application"
    expect_content "Have you submitted"

    expect_status_link 'submit application', 'next'
    expect_status_link 'submit application', 'no change'
    expect_status_link 'submit application', 'skip'
    expect_status_link 'submit application', 'fellow declined'
  end

  describe 'follow up after application' do
    let(:view) { :follow_up_after_application }

    expect_headers "New Opportunity: Follow Up on Your Application"
    expect_content "Have you followed"

    expect_status_link 'follow up after application', 'next'
    expect_status_link 'follow up after application', 'no change'
    expect_status_link 'follow up after application', 'skip'
    expect_status_link 'follow up after application', 'fellow declined'
    expect_status_link 'follow up after application', 'employer declined'
  end

  describe 'schedule interview' do
    let(:view) { :schedule_interview }

    expect_headers "New Opportunity: Schedule an Interview"
    expect_content "Have you scheduled"

    expect_status_link 'schedule interview', 'next'
    expect_status_link 'schedule interview', 'no change'
    expect_status_link 'schedule interview', 'skip'
    expect_status_link 'schedule interview', 'fellow declined'
    expect_status_link 'schedule interview', 'employer declined'
  end

  describe 'research interview process' do
    let(:view) { :research_interview_process }

    expect_headers "New Opportunity: Research the Interview Process"
    expect_content "Have you researched"

    expect_status_link 'research interview process', 'next'
    expect_status_link 'research interview process', 'no change'
    expect_status_link 'research interview process', 'skip'
    expect_status_link 'research interview process', 'fellow declined'
  end

  # describe 'practiced for interview' do
  #   let(:view) { :practiced_for_interview }
  #
  #   expect_headers "New Opportunity: Practice for Your Interview"
  #   expect_content "Have you practiced"
  #
  #   expect_status_link 'practiced for interview'
  #   expect_status_link 'no change'
  #   expect_status_link 'skip'
  #   expect_status_link 'not interested'
  # end
  #
  # describe 'attended interview' do
  #   let(:view) { :attended_interview }
  #
  #   expect_headers "New Opportunity: Ace Your Interview!"
  #   expect_content "Have you attended"
  #
  #   expect_status_link 'attended interview'
  #   expect_status_link 'no change'
  #   expect_status_link 'skip'
  #   expect_status_link 'not interested'
  # end
  #
  # describe 'followed up after interview' do
  #   let(:view) { :followed_up_after_interview }
  #
  #   expect_headers "New Opportunity: Follow Up After Your Interview"
  #   expect_content "Have you followed"
  #
  #   expect_status_link 'followed up after interview'
  #   expect_status_link 'declined'
  #   expect_status_link 'no change'
  #   expect_status_link 'skip'
  #   expect_status_link 'not interested'
  # end
  #
  # describe 'received offer' do
  #   let(:view) { :received_offer }
  #
  #   expect_headers "New Opportunity: Look for an Offer!"
  #   expect_content "Have you received"
  #
  #   expect_status_link 'received offer'
  #   expect_status_link 'declined'
  #   expect_status_link 'no change'
  #   expect_status_link 'skip'
  #   expect_status_link 'not interested'
  # end
  #
  # describe 'submitted counter-offer' do
  #   let(:view) { :submitted_counter_offer }
  #
  #   expect_headers "New Opportunity: Consider a Counter Offer"
  #   expect_content "Have you submitted"
  #
  #   expect_status_link 'submitted counter-offer'
  #   expect_status_link 'accepted offer'
  #   expect_status_link 'no change'
  #   expect_status_link 'skip'
  #   expect_status_link 'not interested'
  # end
  #
  # describe 'accepted offer' do
  #   let(:view) { :accepted_offer }
  #
  #   expect_headers "New Opportunity: Accept Your Offer!"
  #   expect_content "Have you accepted"
  #
  #   expect_status_link 'accepted offer'
  #   expect_status_link 'no change'
  #   expect_status_link 'skip'
  #   expect_status_link 'not interested'
  # end
end
