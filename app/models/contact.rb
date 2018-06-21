class Contact < ApplicationRecord
  STATES = [
    '', 'AK', 'AL', 'AR', 'AZ', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 
    'HI', 'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 
    'ME', 'MI', 'MN', 'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 
    'NJ', 'NM', 'NV', 'NY', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 
    'SD', 'TN', 'TX', 'UT', 'VA', 'VT', 'WA', 'WI', 'WV', 'WY'
  ]

  belongs_to :contactable, polymorphic: true
  
  validates :url, url: {ensure_protocol: true}, allow_blank: true
  validates :state, inclusion: { in: (STATES + [nil]) }
  
  def metro
    pc = PostalCode.find_by code: postal_code
    return nil if pc.nil?
    
    Metro.find_by code: pc.msa_code
  end
  
  def metro_name
    metro && metro.name
  end
end
