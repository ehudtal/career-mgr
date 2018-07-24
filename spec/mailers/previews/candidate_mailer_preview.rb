# Preview all emails at http://localhost:3000/rails/mailers/candidate_mailer
class CandidateMailerPreview < ActionMailer::Preview
  def invitation
    fellow_opportunity = FellowOpportunity.last
    access_token = AccessToken.last

    CandidateMailer.with(access_token: access_token, fellow_opportunity: fellow_opportunity).invitation
  end
end
