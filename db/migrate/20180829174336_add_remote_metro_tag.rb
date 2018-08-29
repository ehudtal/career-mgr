class AddRemoteMetroTag < ActiveRecord::Migration[5.2]
  def tag_name
    'Remote'
  end
  
  def pacifier
    print '.'
    $stdout.flush
  end
  
  def up
    unless Metro.find_by(name: tag_name)
      Metro.create! code: 'REM', name: tag_name, source: 'TOP'
    end

    remote = Metro.find_by(name: tag_name)
    
    Metro.state.each do |state|
      pacifier
      state.parents << remote
    end
    
    puts
  end
  
  def down
    if tag = Metro.find_by(name: tag_name)
      tag.destroy
    end
  end
end
