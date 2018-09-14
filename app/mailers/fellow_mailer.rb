class FellowMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  
  after_action :set_unsubscribe_header

  def profile
    @token = params[:access_token]
    @fellow = @token.owner
    
    mail_subscribed(@fellow.receive_opportunities, to: @fellow.contact.email, subject: "#{@fellow.first_name} - Please update your profile")
  end
  
  private
  
  def set_unsubscribe_header
    link = AccessToken.for(@fellow).path_with_token('Unsubscribe')
    headers['List-Unsubscribe'] = "<#{link}>"
  end
end
