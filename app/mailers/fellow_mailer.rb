class FellowMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def profile
    @token = params[:access_token]
    @fellow = @token.owner
    
    mail_subscribed(@fellow.receive_opportunities, to: @fellow.contact.email, subject: "Please Update Your Profile")
  end
end
