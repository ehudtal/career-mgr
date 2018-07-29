class CandidateMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def respond_to_invitation
    set_objects
    mail(to: @fellow.contact.email, subject: "You've been invited to apply for #{@opp.name}")
  end

  def research_employer
    set_stage 'research employer'
    nag("Research This Employer")
  end

  def connect_with_employees
    set_stage 'connect with employees'
    nag("Connect with Current Employees")
  end

  def customize_application_materials
    set_stage 'customize application materials'
    nag("Customize Your Application Materials")
  end

  def submit_application
    set_stage 'submit application'
    nag("Submit Your Application")
  end

  def follow_up_after_application
    set_stage 'follow up after application'
    nag("Follow Up on Your Application")
  end

  def schedule_interview
    set_stage 'schedule interview'
    nag("Schedule an Interview")
  end

  def research_interview_process
    set_stage 'research interview process'
    nag("Research the Interview Process")
  end

  def practice_for_interview
    set_stage 'practice for interview'
    nag("Practice for Your Interview")
  end

  def attend_interview
    set_stage 'attend interview'
    nag("Ace Your Interview!")
  end

  def follow_up_after_interview
    set_stage 'follow up after interview'
    nag("Follow Up After Your Interview")
  end

  def receive_offer
    set_stage 'receive offer'
    nag("Look for an Offer!")
  end

  def submit_counter_offer
    set_stage 'submit counter-offer'
    nag("Consider a Counter Offer")
  end

  def accept_offer
    set_stage 'accept offer'
    nag("Accept Your Offer!")
  end
  
  private
  
  def nag subject
    set_objects
    @content = @opportunity_stage.content

    if @content
      mail(to: @fellow.contact.email, subject: "#{@opp.name}: #{subject}", template_name: 'notify')
    else
      mail(to: @fellow.contact.email, subject: "#{@opp.name}: #{subject}")
    end
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
