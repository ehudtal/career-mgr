class AddAnywhereMetroTag < ActiveRecord::Migration[5.2]
  def tag_name
    'Anywhere'
  end
  
  def up
    unless Metro.find_by(name: tag_name)
      Metro.create! code: 'ANY', name: tag_name, source: 'TOP'
    end
  end
  
  def down
    if tag = Metro.find_by(name: tag_name)
      tag.destroy
    end
  end
end
