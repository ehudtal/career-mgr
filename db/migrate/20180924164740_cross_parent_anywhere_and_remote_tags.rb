class CrossParentAnywhereAndRemoteTags < ActiveRecord::Migration[5.2]
  def change
    remote = Metro.find_by name: 'Remote'
    anywhere = Metro.find_by name: 'Anywhere'
    
    if remote && anywhere
      remote.children << anywhere
      anywhere.children << remote
    end
  end
end
