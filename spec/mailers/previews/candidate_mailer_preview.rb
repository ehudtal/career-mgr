# Preview all emails at http://localhost:3000/rails/mailers/candidate_mailer
class CandidateMailerPreview < ActionMailer::Preview
  def step_01_respond_to_invitation
    CandidateMailer.with(access_token: access_token).respond_to_invitation
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
  
  def step_05_submitted_application
    CandidateMailer.with(access_token: access_token).submitted_application
  end
  
  def step_06_followed_up_after_application_submission
    CandidateMailer.with(access_token: access_token).followed_up_after_application_submission
  end
  
  def step_07_scheduled_an_interview
    CandidateMailer.with(access_token: access_token).scheduled_an_interview
  end
  
  def step_08_researched_interview_process
    CandidateMailer.with(access_token: access_token).researched_interview_process
  end
  
  def step_09_practiced_for_interview
    CandidateMailer.with(access_token: access_token).practiced_for_interview
  end
  
  def step_10_attended_interview
    CandidateMailer.with(access_token: access_token).attended_interview
  end
  
  def step_11_followed_up_after_interview
    CandidateMailer.with(access_token: access_token).followed_up_after_interview
  end
  
  def step_12_received_offer
    CandidateMailer.with(access_token: access_token).received_offer
  end
  
  def step_13_submitted_counter_offer
    CandidateMailer.with(access_token: access_token).submitted_counter_offer
  end
  
  def step_14_accepted_offer
    CandidateMailer.with(access_token: access_token).accepted_offer
  end
  
  private
  
  def access_token
    return @access_token if defined?(@access_token)
    @access_token = AccessToken.for(FellowOpportunity.last)
  end
end
