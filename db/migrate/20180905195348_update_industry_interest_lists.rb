require 'yaml'

class UpdateIndustryInterestLists < ActiveRecord::Migration[5.2]
  def up
    # industries
    names = YAML.load(File.read("#{Rails.root}/config/industries.yml"))
    
    # remove those not on this new list
    Industry.where.not(name: names).destroy_all
    
    names.each do |name|
      Industry.find_or_create_by name: name
    end
    
    # interests
    names = YAML.load(File.read("#{Rails.root}/config/interests.yml"))
    
    # remove those not on this new list
    Interest.where.not(name: names).destroy_all
    
    names.each do |name|
      Interest.find_or_create_by name: name
    end
  end
  
  def down
    puts "Not reversible, but not the end of the world, either."
  end
end
