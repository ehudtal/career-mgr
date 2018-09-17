class BackfillFellowCareerSteps < ActiveRecord::Migration[5.2]
  def change
    Fellow.all.each do |fellow|
      fellow.send(:generate_career_steps)
      print '.'; $stdout.flush
    end
    
    puts
  end
end
