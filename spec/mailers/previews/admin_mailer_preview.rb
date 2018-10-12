# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  def application_submitted
    fellow_opportunity = FellowOpportunity.last
    AdminMailer.with(fellow_opportunity: fellow_opportunity).application_submitted
  end
end
