class CandidateMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def invitation
    @token = params[:access_token]
    @fellow_opp = params[:fellow_opportunity]
    @fellow = @fellow_opp.fellow
    @opp = @fellow_opp.opportunity
    
    mail(to: @fellow.contact.email, subject: "You've been invited to apply for #{@opp.name}")
  end
end
