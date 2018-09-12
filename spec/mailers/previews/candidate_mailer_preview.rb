# Preview all emails at http://localhost:3000/rails/mailers/candidate_mailer
class CandidateMailerPreview < ActionMailer::Preview
  def step_01_respond_to_invitation
    CandidateMailer.with(access_token: access_token).respond_to_invitation
  end
  
  def step_02_research_employer
    CandidateMailer.with(access_token: access_token, stage_name: 'research employer').notify
  end
  
  def step_03_connect_with_employees
    CandidateMailer.with(access_token: access_token, stage_name: 'connect with employees').notify
  end
  
  def step_04_customize_application_materials
    CandidateMailer.with(access_token: access_token, stage_name: 'customize application materials').notify
  end
  
  def step_05_submit_application
    CandidateMailer.with(access_token: access_token, stage_name: 'submit application').notify
  end
  
  def step_06_follow_up_after_application
    CandidateMailer.with(access_token: access_token, stage_name: 'follow up after application').notify
  end
  
  def step_07_schedule_interview
    CandidateMailer.with(access_token: access_token, stage_name: 'schedule interview').notify
  end
  
  def step_08_research_interview_process
    CandidateMailer.with(access_token: access_token, stage_name: 'research interview process').notify
  end
  
  def step_09_practice_for_interview
    CandidateMailer.with(access_token: access_token, stage_name: 'practice for interview').notify
  end
  
  def step_10_attend_interview
    CandidateMailer.with(access_token: access_token, stage_name: 'attend interview').notify
  end
  
  def step_11_follow_up_after_interview
    CandidateMailer.with(access_token: access_token, stage_name: 'follow up after interview').notify
  end
  
  def step_12_receive_offer
    CandidateMailer.with(access_token: access_token, stage_name: 'receive offer').notify
  end
  
  def step_13_submit_counter_offer
    CandidateMailer.with(access_token: access_token, stage_name: 'submit counter-offer').notify
  end
  
  def step_14_accept_offer
    CandidateMailer.with(access_token: access_token, stage_name: 'accept offer').notify
  end
  
  private
  
  def access_token
    return @access_token if defined?(@access_token)
    @access_token = AccessToken.for(FellowOpportunity.last)
  end
end
