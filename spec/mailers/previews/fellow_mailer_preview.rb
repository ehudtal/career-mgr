# Preview all emails at http://localhost:3000/rails/mailers/fellow_mailer
class FellowMailerPreview < ActionMailer::Preview
  def profile
    access_token = AccessToken.for(Fellow.last)
    FellowMailer.with(access_token: access_token).profile
  end
end
