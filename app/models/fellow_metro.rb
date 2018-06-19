class FellowMetro < ApplicationRecord
  self.table_name = 'fellows_metros'
  
  def self.fellow_ids_for metro_ids
    where(metro_id: metro_ids).pluck(:fellow_id).uniq
  end
end
