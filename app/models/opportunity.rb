class Opportunity < ApplicationRecord
  belongs_to :employer
  
  has_many :tasks, as: :taskable
  
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :interests
  has_and_belongs_to_many :locations
  
  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  
  before_save :normalize_url
  
  private
  
  def normalize_url
    unless job_posting_url.blank? || job_posting_url =~ /^http/
      self.job_posting_url = "http://#{job_posting_url}"
    end
  end
end
