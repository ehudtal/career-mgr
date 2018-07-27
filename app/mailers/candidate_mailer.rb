class CandidateMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def invitation
    set_objects
    mail(to: @fellow.contact.email, subject: "You've been invited to apply for #{@opp.name}")
  end

  def researched_employer
    set_objects
    mail(to: @fellow.contact.email, subject: "#{@opp.name}: Research This Employer")
  end

  def connected_with_employees
    set_objects
    mail(to: @fellow.contact.email, subject: "#{@opp.name}: Connect with Current Employees")
  end

  def customized_application_materials
    set_objects
    mail(to: @fellow.contact.email, subject: "#{@opp.name}: Customized Your Application Materials")
  end

  def submitted_application
    set_objects
    mail(to: @fellow.contact.email, subject: "#{@opp.name}: Submit Your Application")
  end
  
  private
  
  def set_objects
    @token = params[:access_token]
    @fellow_opp = @token.owner
    @fellow = @fellow_opp.fellow
    @opp = @fellow_opp.opportunity
  end
end
