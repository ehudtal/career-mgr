class AddMetroAssociations < ActiveRecord::Migration[5.2]
  def remove_associations
    ActiveRecord::Base.connection.execute('delete from metro_relationships;')
  end
  
  def pacifier
    print '.'
    $stdout.flush
  end
  
  def up
    remove_associations
    
    anywhere = Metro.find_by(name: 'Anywhere')
    
    Metro.state.each do |state|
      pacifier
      state.parents << anywhere
    end
    
    Metro.city.each do |city|
      city.states.each do |code|
        pacifier
        state = Metro.find_by(code: code)
        city.parents << state if state
      end
    end
    
    puts
  end
  
  def down
    remove_associations
  end
end
