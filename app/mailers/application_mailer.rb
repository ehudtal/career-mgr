class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.mailer_from_email
  layout 'mailer'
end
