require 'access_token_split'

Split.configure do |config|
  config.experiments = YAML.load_file "config/experiments.yml"
  config.redis = Rails.application.secrets.redis_url
end

Split::Dashboard.use Rack::Auth::Basic do |username, password|
  user1 = ::Digest::SHA256.hexdigest(username)
  user2 = ::Digest::SHA256.hexdigest(Rails.application.secrets.split_username)
  
  pass1 = ::Digest::SHA256.hexdigest(password)
  pass2 = ::Digest::SHA256.hexdigest(Rails.application.secrets.split_password)

  ActiveSupport::SecurityUtils.secure_compare(user1, user2) &
    ActiveSupport::SecurityUtils.secure_compare(pass1, pass2)
end