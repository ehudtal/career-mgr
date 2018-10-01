class AccessTokenSplit
  attr_reader :token, :name
  
  def initialize access_token, experiment_name
    @token = access_token.code
    @name = experiment_name
    
    value
  end
  
  def value
    return @value if defined?(@value)
    
    trial.choose!
    @value = trial.alternative.name
  end
  
  def settings
    return @settings if defined?(@settings)
    @settings = trial.metadata
  end
  
  def finish goal=nil
    trial.choose!

    unless already_finished?
      goal ? trial.complete!(goal) : trial.complete!
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
    @experiment = Split::ExperimentCatalog.find_or_create(name)
  end
  
  def trial
    return @trial if defined?(@trial)
    @trial = Split::Trial.new(user: user, experiment: experiment)
  end
  
  private
  
  def tokenize string_or_symbol
    string_or_symbol.to_s.downcase.gsub(/\s+/, '-').gsub(/[^a-z0-9-]/, '')
  end
  
  def already_finished?
    user[experiment.finished_key]
  end
  
  def finish!
    user[experiment.finished_key] = true
  end
end