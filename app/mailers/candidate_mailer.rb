class CandidateMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def respond_to_invitation
    set_objects
    mail(to: @fellow.contact.email, subject: "You've been invited to apply for #{@opp.name}")
  end

  def research_employer
    nag("Research This Employer")
  end

  def connected_with_employees
    nag("Connect with Current Employees")
  end

  def customized_application_materials
    nag("Customized Your Application Materials")
  end

  def submitted_application
    nag("Submit Your Application")
  end

  def followed_up_after_application_submission
    nag("Follow Up on Your Application")
  end

  def scheduled_an_interview
    nag("Schedule an Interview")
  end

  def researched_interview_process
    nag("Research the Interview Process")
  end

  def practiced_for_interview
    nag("Practice for Your Interview")
  end

  def attended_interview
    nag("Ace Your Interview!")
  end

  def followed_up_after_interview
    nag("Follow Up After Your Interview")
  end

  def received_offer
    nag("Look for an Offer!")
  end

  def submitted_counter_offer
    nag("Consider a Counter Offer")
  end

  def accepted_offer
    nag("Accept Your Offer!")
  end
  
  private
  
  def nag subject
    set_objects
    mail(to: @fellow.contact.email, subject: "#{@opp.name}: #{subject}")
  end
  
  def set_objects
    @token = params[:access_token]
    @fellow_opp = @token.owner
    @fellow = @fellow_opp.fellow
    @opp = @fellow_opp.opportunity
  end
end
