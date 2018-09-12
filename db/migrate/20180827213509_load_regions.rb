class LoadRegions < ActiveRecord::Migration[5.2]
  def up
    Region.destroy_all

    Region.types.each_with_index do |name, position|
      Region.create name: name, position: position
      print '.'; $stdout.flush
    end
    
    puts
    
    nationwide = Region.find_by name: 'Nationwide'
    Opportunity.update_all(region_id: nationwide.id)
  end
  
  def down
    Region.destroy_all
    Opportunity.update_all(region_id: nil)
  end
end
