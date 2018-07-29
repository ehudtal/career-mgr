# Preview all emails at http://localhost:3000/rails/mailers/candidate_mailer
class CandidateMailerPreview < ActionMailer::Preview
  def step_01_respond_to_invitation
    CandidateMailer.with(access_token: access_token).respond_to_invitation
  end
  
  def step_02_research_employer
    CandidateMailer.with(access_token: access_token).research_employer
  end
  
  def step_03_connect_with_employees
    CandidateMailer.with(access_token: access_token).connect_with_employees
  end
  
  def step_04_customize_application_materials
    CandidateMailer.with(access_token: access_token).customize_application_materials
  end
  
  def step_05_submit_application
    CandidateMailer.with(access_token: access_token).submit_application
  end
  
  def step_06_follow_up_after_application
    CandidateMailer.with(access_token: access_token).follow_up_after_application
  end
  
  def step_07_schedule_interview
    CandidateMailer.with(access_token: access_token).schedule_interview
  end
  
  def step_08_research_interview_process
    CandidateMailer.with(access_token: access_token).research_interview_process
  end
  
  def step_09_practice_for_interview
    CandidateMailer.with(access_token: access_token).practice_for_interview
  end
  
  def step_10_attend_interview
    CandidateMailer.with(access_token: access_token).attend_interview
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
