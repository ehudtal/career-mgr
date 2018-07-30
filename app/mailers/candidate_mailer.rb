class CandidateMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def respond_to_invitation
    set_objects
    mail(to: @fellow.contact.email, subject: "You've been invited to apply for #{@opp.name}")
  end

  def research_employer
    set_stage 'research employer'
    nag
  end

  def connect_with_employees
    set_stage 'connect with employees'
    nag
  end

  def customize_application_materials
    set_stage 'customize application materials'
    nag
  end

  def submit_application
    set_stage 'submit application'
    nag
  end

  def follow_up_after_application
    set_stage 'follow up after application'
    nag
  end

  def schedule_interview
    set_stage 'schedule interview'
    nag
  end

  def research_interview_process
    set_stage 'research interview process'
    nag
  end

  def practice_for_interview
    set_stage 'practice for interview'
    nag
  end

  def attend_interview
    set_stage 'attend interview'
    nag
  end

  def follow_up_after_interview
    set_stage 'follow up after interview'
    nag
  end

  def receive_offer
    set_stage 'receive offer'
    nag
  end

  def submit_counter_offer
    set_stage 'submit counter-offer'
    nag
  end

  def accept_offer
    set_stage 'accept offer'
    nag
  end
  
  private
  
  def nag
    set_objects
    @content = @opportunity_stage.content

    mail(to: @fellow.contact.email, subject: "#{@opp.name}: #{@content['title']}", template_name: 'notify')
  end
  
  def set_stage stage_name
    @opportunity_stage = OpportunityStage.find_by(name: stage_name)
  end
  
  def set_objects
    @token = params[:access_token]
    @fellow_opp = @token.owner
    @fellow = @fellow_opp.fellow
    @opp = @fellow_opp.opportunity
  end
end
