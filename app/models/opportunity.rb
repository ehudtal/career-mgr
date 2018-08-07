require 'taggable'

class Opportunity < ApplicationRecord
  include Taggable
  
  belongs_to :employer
  
  has_many :tasks, as: :taskable, dependent: :destroy
  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true
  
  has_many :fellow_opportunities
  has_many :fellows, through: :fellow_opportunities
  
  taggable :industries, :interests, :majors, :industry_interests, :metros

  has_and_belongs_to_many :locations, dependent: :destroy, after_add: :attach_metro
  accepts_nested_attributes_for :locations, reject_if: :all_blank, allow_destroy: true
  
  serialize :steps, Array
  
  validates :name, presence: true
  validates :job_posting_url, url: {ensure_protocol: true}, allow_blank: true
  
  def candidates search_params=nil
    search_params ||= {}
    return @candidates if defined?(@candidates)
    
    candidate_ids = Fellow.pluck(:id)
    
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
  
  def fellow_ids_for_industries_interests names
    industry_fellow_ids = fellow_ids_for_industries names
    interest_fellow_ids = fellow_ids_for_interests names
    
    industry_fellow_ids | interest_fellow_ids
  end
  
  def fellow_ids_for_metros names
    selected_ids = if names
      Metro.where(name: names.split(';')).pluck(:id)
    else
      metro_ids
    end
    
    state_ids = state_ids_for_metro_ids(selected_ids)
    city_ids = metro_ids_for_state_ids(selected_ids)
    
    FellowMetro.fellow_ids_for(selected_ids + state_ids + city_ids)
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
    locations.map(&:contact).map(&:postal_code)
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
end
