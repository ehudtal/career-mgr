class FellowIndustry < ApplicationRecord
  self.table_name = 'employers_industries'
  
  def self.employer_ids_for industry_ids
    where(industry_id: industry_ids).pluck(:employer_id).uniq
  end
end
