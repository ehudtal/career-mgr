class FellowMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def profile
    @token = params[:access_token]
    @fellow = params[:fellow]
    
    mail(to: @fellow.contact.email, subject: "Please Update Your Profile")
  end
end
