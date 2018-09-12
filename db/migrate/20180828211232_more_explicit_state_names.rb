class MoreExplicitStateNames < ActiveRecord::Migration[5.2]
  def up
    Metro.state.each do |metro|
      next if metro.name =~ /\(Statewide\)$/
      metro.update name: "#{metro.name} (Statewide)"
    end
  end
  
  def down
    Metro.state.each do |metro|
      next unless metro.name =~ /\(Statewide\)$/
      metro.update name: metro.name.match(/^(.*)\s+\(Statewide\)/)[1]
    end
  end
end
