class CandidateMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def invitation
    set_objects
    mail(to: @fellow.contact.email, subject: "You've been invited to apply for #{@opp.name}")
  end

  def application_submitted
    set_objects
    mail(to: @fellow.contact.email, subject: "Have You Submitted Your Application for #{@opp.name}?")
  end
  
  private
  
  def set_objects
    @token = params[:access_token]
    @fellow_opp = @token.owner
    @fellow = @fellow_opp.fellow
    @opp = @fellow_opp.opportunity
  end
end
