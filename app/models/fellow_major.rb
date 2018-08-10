class FellowMajor < ApplicationRecord
  self.table_name = 'fellows_majors'
  
  def self.fellow_ids_for major_ids
    where(major_id: major_ids).pluck(:fellow_id).uniq
  end
end
