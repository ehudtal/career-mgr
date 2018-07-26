# Preview all emails at http://localhost:3000/rails/mailers/candidate_mailer
class CandidateMailerPreview < ActionMailer::Preview
  def step_01_invitation
    CandidateMailer.with(access_token: access_token).invitation
  end
  
  def step_02_applying
    CandidateMailer.with(access_token: access_token).applying
  end
  
  def step_03_application_submitted
    CandidateMailer.with(access_token: access_token).application_submitted
  end
  
  private
  
  def access_token
    return @access_token if defined?(@access_token)
    @access_token = AccessToken.for(FellowOpportunity.last)
  end
end
