class AccessTokenSplit
  attr_reader :token, :name, :variants
  
  def initialize access_token, experiment_name, variants=[]
    @token = access_token.code
    @name = experiment_name
    @variants = variants
  end
  
  def select
    trial.choose!
    trial.alternative.name
  end
  
  def finish
    trial.choose!

    unless already_finished?
      trial.complete!
      finish!
    end
  end
  
  def key
    return @key if defined?(@key)
    @key = [tokenize(name), token].join(':')
  end
  
  def user
    return @user if defined?(@user)
    @user = Split::User.new(nil, Split::Persistence::RedisAdapter.new(nil, key))
  end
  
  def experiment
    return @experiment if defined?(@experiment)

    @experiment = if variants.empty?
      Split::ExperimentCatalog.find(name)
    else
      Split::ExperimentCatalog.find_or_create(name, *variants)
    end
  end
  
  def trial
    return @trial if defined?(@trial)
    @trial = Split::Trial.new(user: user, experiment: experiment)
  end
  
  private
  
  def tokenize string
    string.downcase.gsub(/\s+/, '-').gsub(/[^a-z0-9-]/, '')
  end
  
  def already_finished?
    user[experiment.finished_key]
  end
  
  def finish!
    user[experiment.finished_key] = true
  end
end