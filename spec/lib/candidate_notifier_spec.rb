require 'rails_helper'
require 'candidate_notifier'

RSpec.describe CandidateNotifier do
  let(:access_token) { build :access_token }
  
  def delayed_mailer
    return @delayed_mailer if defined?(@delayed_mailer)
    
    dj = Delayed::Job.where(queue: 'mailers').last
    return @delayed_mailer = {} if dj.nil?

    args = YAML.load(dj.handler).job_data['arguments']

    @delayed_mailer = {
      class: args[0],
      view: args[1],
      token: AccessToken.find(args[3]['access_token']['_aj_globalid'].split('/').last),
      stage_name: args[3]['stage_name'],
      params: args[3]
    }
  end
  
  def expect_mailer mailer_route, params
    class_name, view = mailer_route.split('#')
    expect(delayed_mailer[:class]).to eq(class_name)
    expect(delayed_mailer[:view]).to eq(view)
    expect(delayed_mailer[:token]).to eq(params[:access_token])
    expect(delayed_mailer[:stage_name]).to eq(params[:stage_name])
  end
  
  describe '::MAILER_FREQUENCY' do
    subject { CandidateNotifier::MAILER_FREQUENCY }
    it { should eq(24) }
  end
  
  describe '::send_notifications' do
    let(:access_token) { AccessToken.for(fellow_opportunity) }
    let(:fellow_opportunity) { create :fellow_opportunity, fellow: fellow, opportunity: opportunity, opportunity_stage: opportunity_stage, last_contact_at: last_contact_at, active: active }
    let(:fellow) { create :fellow }
    let(:opportunity) { create :opportunity }
    let(:opportunity_stage) { create :opportunity_stage, name: stage_name}
    let(:stage_name) { 'research employer' }
    let(:active) { true }
    let(:delayed_job_count) { Delayed::Job.count }
    
    before do
      access_token 
      delayed_job_count
      CandidateNotifier.send_notifications
    end
    
    describe 'when last contact was more than three days ago' do
      let(:last_contact_at) { (CandidateNotifier::MAILER_FREQUENCY + 1).hours.ago }
      
      it "sends the 'notify' mailer, with the proper stage name" do
        expect_mailer 'CandidateMailer#notify', access_token: access_token, stage_name: stage_name
      end
      
      it "updates the last_contact_at field" do
        expect(fellow_opportunity.reload.last_contact_at).to be_within(0.1).of(Time.now)
      end
    end
    
    describe 'when last contact was less than three days ago' do
      let(:last_contact_at) { (CandidateNotifier::MAILER_FREQUENCY - 1).hours.ago }
      
      it 'doesn\'t notify the candidate' do
        expect(Delayed::Job.where(queue: 'mailers').count).to eq(delayed_job_count)
      end
      
      it "DOES NOT update the last_contact_at field" do
        expect(fellow_opportunity.reload.last_contact_at).to be_within(1).of(last_contact_at)
      end
    end
    
    describe 'when fellow has never responded' do
      let(:last_contact_at) { 73.hours.ago }
      let(:stage_name) { 'respond to invitation' }
      
      it "sends the respond_to_invitation mailer" do
        expect_mailer 'CandidateMailer#respond_to_invitation', access_token: access_token
      end
      
      it "updates the last_contact_at field" do
        expect(fellow_opportunity.reload.last_contact_at).to be_within(0.1).of(Time.now)
      end
    end
    
    describe 'when fellow_opportunity is no longer active' do
      let(:last_contact_at) { 100.days.ago }
      let(:active) { false }
      
      it 'doesn\'t notify the candidate' do
        expect(Delayed::Job.where(queue: 'mailers').count).to eq(delayed_job_count)
      end

      it "DOES NOT update the last_contact_at field" do
        expect(fellow_opportunity.reload.last_contact_at).to be_within(1).of(last_contact_at)
      end
    end
  end
end