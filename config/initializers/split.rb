require 'access_token_split'

Split.configure do |config|
  config.experiments = YAML.load_file "config/experiments.yml"
  config.redis = Rails.application.secrets.redis_url
end