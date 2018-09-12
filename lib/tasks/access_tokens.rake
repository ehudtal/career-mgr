namespace :access_tokens do
  desc "remove expired access tokens"
  task expire: :environment do
    AccessToken.expire_tokens
  end

end
