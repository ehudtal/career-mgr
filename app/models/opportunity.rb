require 'taggable'

class Opportunity < ApplicationRecord
  include Taggable
  
  belongs_to :employer
  belongs_to :opportunity_type
  belongs_to :region
  
  has_many :tasks, as: :taskable, dependent: :destroy
  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true
  
  has_many :fellow_opportunities
  has_many :fellows, through: :fellow_opportunities
  
  taggable :industries, :interests, :majors, :industry_interests, :metros

  has_and_belongs_to_many :locations, dependent: :destroy, after_add: :attach_metro
  accepts_nested_attributes_for :locations, reject_if: :all_blank, allow_destroy: true
  
  serialize :steps, Array
  
  validates :name, presence: true
  validates :job_posting_url, url: {ensure_protocol: true}
  validate :validate_locateable
  
  scope :prioritized, -> { order(priority: :asc) }
  
  before_save :set_priority
  
  class << self
    def csv_headers
      ['Region', 'Employer', 'Position', 'Type', 'Location', 'Link', 'Employer Partner', 'Inbound', 'Recurring', 'Interests']
    end
  end
  
  def candidates search_params=nil
    search_params ||= {}
    return @candidates if defined?(@candidates)
    
    candidate_ids = Fellow.receive_opportunities.pluck(:id)
    
    candidate_ids &= fellow_ids_for_opportunity_type
    
    unless search_params[:industries_interests] == ''
      candidate_ids &= fellow_ids_for_industries_interests(search_params[:industries_interests])
    end

    unless search_params[:metros] == ''
      candidate_ids &= fellow_ids_for_metros(search_params[:metros])
    end
    
    candidate_ids.uniq!
    
    # remove already-activated candidates
    candidate_ids -= fellow_opportunities.pluck(:fellow_id)
    
    @candidates = Fellow.where(id: candidate_ids)
  end
  
  def formatted_name
    [employer.name, name].join(' - ')
  end
  
  def fellow_ids_for_opportunity_type
    self.class.connection.query("select fellow_id from fellows_opportunity_types where opportunity_type_id = #{opportunity_type.id}").flatten.uniq
  end
  
  def fellow_ids_for_interests names
    selected_ids = if names
      Interest.where(name: names.split(';')).pluck(:id)
    else
      interest_ids
    end
    
    FellowInterest.fellow_ids_for(selected_ids)
  end
  
  def fellow_ids_for_industries names
    selected_ids = if names
      Industry.where(name: names.split(';')).pluck(:id)
    else
      industry_ids
    end
    
    FellowIndustry.fellow_ids_for(selected_ids)
  end
  
  def fellow_ids_for_majors names
    named = if names
      Major.where(name: names.split(';'))
    else
      majors
    end
    
    parent_ids = named.map(&:all_parents).flatten.uniq.map(&:id)
    child_ids = named.map(&:all_children).flatten.uniq.map(&:id)
    
    selected_ids = (named.pluck(:id) + parent_ids + child_ids).uniq
    
    FellowMajor.fellow_ids_for(selected_ids)
  end
  
  def fellow_ids_for_industries_interests names
    industry_fellow_ids = fellow_ids_for_industries names
    interest_fellow_ids = fellow_ids_for_interests names
    major_fellow_ids = fellow_ids_for_majors names
    
    industry_fellow_ids | interest_fellow_ids | major_fellow_ids
  end
  
  def fellow_ids_for_metros names
    named = if names
      Metro.where(name: names.split(';'))
    else
      metros
    end
    
    parent_ids = named.map(&:all_parents).flatten.uniq.map(&:id)
    child_ids = named.map(&:all_children).flatten.uniq.map(&:id)
    
    selected_ids = (named.pluck(:id) + parent_ids + child_ids).uniq
    
    FellowMetro.fellow_ids_for(selected_ids)
  end
  
  def state_ids_for_metro_ids metro_ids
    state_abbrs = Metro.city.where(id: metro_ids).map(&:states).flatten.uniq
    Metro.where(code: state_abbrs).pluck(:id)
  end
  
  def metro_ids_for_state_ids metro_ids
    state_abbrs = Metro.state.where(id: metro_ids).pluck(:code)
    Metro.city.reject{|c| (c.states & state_abbrs).empty?}.map(&:id)
  end
  
  def candidate_ids= candidate_id_list
    initial_stage = OpportunityStage.find_by position: 0
    
    fellow_opps = candidate_id_list.map do |candidate_id|
      if archived = archived_fellow_opp(candidate_id)
        archived.restore
      else
        fellow_opportunities.create! fellow_id: candidate_id, opportunity_stage: initial_stage
      end
    end
    
    notify_candidates(fellow_opps)
  end
  
  def notify_candidates fellow_opportunities_list
    fellow_opportunities_list.each do |fellow_opp|
      access_token = AccessToken.for(fellow_opp)
      CandidateMailer.with(access_token: access_token).respond_to_invitation.deliver_later
    end
  end
  
  def postal_codes
    locations.map(&:contact).compact.map(&:postal_code).compact
  end
  
  def csv_fields
    begin
      [
        region.name,
        employer.name,
        name,
        opportunity_type.name,
        primary_city_state,
        job_posting_url,
        (employer.employer_partner ? 'yes' : 'no'),
        (inbound ? 'yes' : 'no'),
        (recurring ? 'yes' : 'no'),
        (interests + industries + majors).map(&:name).uniq.sort.join(', ')
      ]
    # rescue => e
    #   Rails.logger.info("COULD NOT EXPORT OPP #{id}: #{e.message}")
    #   nil
    end
  end
  
  def primary_city_state
    if metros.first
      metro_name = metros.first.name
      
      city, state = metro_name.split(/,\s+/)
    
      return metro_name unless state
      primary_state, secondary_state = state.split('-', 2)
    
      [city, primary_state].join(', ')
    else
      contact = locations.first.contact
      
      [contact.city, contact.state].join(', ')
    end
  end
  
  # lowest priority is best/first
  def calculated_priority
    employer_partner = employer.employer_partner
    
    value = if employer_partner && inbound && recurring
      0
    elsif employer_partner && inbound
      1
    elsif inbound
      2
    elsif employer_partner && recurring
      3
    elsif employer_partner
      4
    elsif recurring
      5
    else
      6
    end
    
    value += 10 if published?
    
    value
  end
  
  def unpublish!
    update published: false
  end
  
  private
  
  def archived_fellow_opp candidate_id
    FellowOpportunity.with_deleted.find_by(opportunity_id: self.id, fellow_id: candidate_id)
  end
  
  def attach_metro location
    return if location.contact.nil?
    
    metro = location.contact.metro
    return if metro.nil?
    
    metros << metro unless metros.include?(metro)
  end
  
  def validate_locateable
    errors.add(:location, "must contain a zip code or a metro area") unless is_locateable?
  end
  
  def is_locateable?
    has_metro? || has_postal_code?
  end
  
  def has_metro?
    !metros.empty?
  end
  
  def has_postal_code?
    !postal_codes.empty?
  end
  
  def set_priority
    self.priority = calculated_priority
  end
end
