class Opportunity < ApplicationRecord
  belongs_to :employer
  
  has_many :tasks, as: :taskable
  
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :interests
  has_and_belongs_to_many :locations
  
  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :job_posting_url, url: {ensure_protocol: true}, allow_blank: true
end
