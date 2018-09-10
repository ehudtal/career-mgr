class OptFellowsIntoAllOpportunityTypes < ActiveRecord::Migration[5.2]
  def change
    count = 0
    Fellow.all.each do |fellow|
      fellow.select_all_opportunity_types
      count += 1
      $stdout.print '.'; $stdout.flush
    end
    
    print "\nOpted #{count} fellows into all opportunity types"
  end
end
