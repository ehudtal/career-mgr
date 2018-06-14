class FellowInterest < ApplicationRecord
  self.table_name = 'fellows_interests'
  
  def self.fellow_ids_for interest_ids
    where(interest_id: interest_ids).pluck(:fellow_id).uniq
  end
end
