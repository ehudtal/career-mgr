# Preview all emails at http://localhost:3000/rails/mailers/fellow_mailer
class FellowMailerPreview < ActionMailer::Preview
  def profile
    fellow = Fellow.last
    access_token = AccessToken.last

    FellowMailer.with(access_token: access_token, fellow: fellow).profile
  end
end
