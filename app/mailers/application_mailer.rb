class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.mailer_from_email
  layout 'mailer'
  
  alias_method :direct_mail, :mail
  
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
end
