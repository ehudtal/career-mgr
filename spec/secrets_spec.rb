require 'rails_helper'

RSpec.describe "Application Secrets" do
  describe 'mailer_bcc' do
    subject { Rails.application.secrets.mailer_bcc }
    
    it { should_not be_nil }
    it { should match(/.+\@.+\..+/) }
  end
end