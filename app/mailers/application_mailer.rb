class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.mailer_from_email
  layout 'mailer'
  
  after_action :set_unsubscribe_header
  
  alias_method :direct_mail, :mail
  
  private
  
  def mail options={}
    raise "Do not use the mail method directly, use mail_subscribed to prevent mailing unsubscribers."
  end
  
  def mail_subscribed subscribed, params={}
    if subscribed
      direct_mail(params)
    else
      Rails.logger.info("COULD NOT E-MAIL #{params[:to]} due to subscription preferences")
    end
  end
  
  def set_unsubscribe_header
    if @unsubscriber
      link = AccessToken.for(@unsubscriber).path_with_token('Unsubscribe')
      headers['List-Unsubscribe'] = "<#{link}>"
    end
  end
end
