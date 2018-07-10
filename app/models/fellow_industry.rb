class FellowIndustry < ApplicationRecord
  self.table_name = 'fellows_industries'
  
  def self.fellow_ids_for industry_ids
    where(industry_id: industry_ids).pluck(:fellow_id).uniq
  end
end
