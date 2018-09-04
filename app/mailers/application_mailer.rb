class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.mailer_from_email
  layout 'mailer'
  
  private
  
  def mail_subscribed subscribed, params={}
    if subscribed
      mail(params)
    else
      Rails.logger.info("COULD NOT E-MAIL #{params[:to]} due to subscription preferences")
    end
  end
end
