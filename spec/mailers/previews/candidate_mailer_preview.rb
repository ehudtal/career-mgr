# Preview all emails at http://localhost:3000/rails/mailers/candidate_mailer
class CandidateMailerPreview < ActionMailer::Preview
  def step_01_invitation
    CandidateMailer.with(access_token: access_token).invitation
  end
  
  def step_02_researched_employer
    CandidateMailer.with(access_token: access_token).researched_employer
  end
  
  def step_03_connected_with_employees
    CandidateMailer.with(access_token: access_token).connected_with_employees
  end
  
  def step_04_customized_application_materials
    CandidateMailer.with(access_token: access_token).customized_application_materials
  end
  
  def step_10_application_submitted
    CandidateMailer.with(access_token: access_token).application_submitted
  end
  
  private
  
  def access_token
    return @access_token if defined?(@access_token)
    @access_token = AccessToken.for(FellowOpportunity.last)
  end
end
