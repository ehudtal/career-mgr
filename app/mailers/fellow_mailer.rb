class FellowMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def profile
    @token = params[:access_token]
    @fellow = @token.owner
    
    mail(to: @fellow.contact.email, subject: "@fellow.contact.name - Please update your profile")
  end
end
