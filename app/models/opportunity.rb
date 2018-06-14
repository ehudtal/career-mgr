class Opportunity < ApplicationRecord
  belongs_to :employer
  
  has_many :tasks, as: :taskable, dependent: :destroy
  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true
  
  has_and_belongs_to_many :industries, dependent: :destroy
  has_and_belongs_to_many :interests, dependent: :destroy

  has_and_belongs_to_many :locations, dependent: :destroy
  accepts_nested_attributes_for :locations, reject_if: :all_blank, allow_destroy: true
  

  validates :name, presence: true
  validates :job_posting_url, url: {ensure_protocol: true}, allow_blank: true
  
  def candidates
    return @candidates if defined?(@@candidates)
    
    candidate_ids = []
    
    candidate_ids += FellowInterest.fellow_ids_for(interest_ids)
    candidate_ids += FellowIndustry.fellow_ids_for(industry_ids)
    
    @candidates = Fellow.where(id: candidate_ids)
  end
end
