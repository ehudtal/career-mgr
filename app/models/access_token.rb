require 'digest/md5'
require 'uri'
require 'cgi'

class AccessToken < ApplicationRecord
  belongs_to :owner, polymorphic: true

  serialize :routes, JSON
  
  before_validation :generate_token
  before_create :set_expiration

  validates :code, presence: true, uniqueness: true
  validate :valid_routes_structure
  
  class << self
    def expire_tokens
      where("expires_at < ?", Time.now).destroy_all
    end
    
    def for owner
      raise "no token routes are defined for this object type." unless valid_token_owner?(owner)
      find_by(owner: owner) || create(owner: owner, routes: routes_for(owner))
    end
    
    def valid_token_owner? owner
      self.respond_to?(route_method_name(owner))
    end
    
    def route_method_name owner
      :"routes_for_#{owner.class.name.underscore}"
    end
    
    def routes_for owner
      send(route_method_name(owner), owner)
    end
    
    def routes_for_fellow fellow
      [
        {label: 'view', method: 'GET', params: {controller: 'admin/fellows', action: 'show', id: fellow.id.to_s}},
        {label: 'Edit Your Profile', method: 'GET', params: {controller: 'fellows', action: 'edit', id: fellow.id.to_s}},
        {label: 'Update Your Profile', method: 'PUT', params: {controller: 'fellows', action: 'update', id: fellow.id.to_s}},
        {label: 'Unsubscribe', method: 'GET', params: {controller: 'fellow/profiles', action: 'unsubscribe'}}
      ]
    end
    
    def routes_for_fellow_opportunity fellow_opportunity
      allowed_routes = []
      
      allowed_statuses = [
        'no change', 'skip', 'next',
        'research employer', 'connect with employees', 'customize application materials', 'submit application', 'follow up after application',
        'schedule interview', 'research interview process', 'practice for interview', 'attend interview', 'follow up after interview',
        'receive offer', 'submit counter-offer', 'accept offer',
        'fellow accepted', 'fellow declined', 'employer declined'
      ].join('|')
      
      allowed_routes << {label: 'status', method: 'GET', params: {controller: 'candidates', action: 'status', fellow_opportunity_id: fellow_opportunity.id.to_s, update: /^(#{allowed_statuses})$/}}
      allowed_routes << {label: 'view', method: 'GET', params: {controller: 'fellow/opportunities', action: 'show', id: fellow_opportunity.id.to_s}}
      allowed_routes << {label: 'update', method: 'PUT', params: {controller: 'fellow/opportunities', action: 'update', id: fellow_opportunity.id.to_s}}
      
      allowed_routes
    end
  end
  
  def route_for label=nil
    return routes.first if label.nil?
    routes.detect{|route| route['label'] == label} || raise("Access Token Route \"#{label}\" does not exist")
  end
  
  def match? request
    routes.any? do |route|
      debug(route, request) if false
      
      method_match?(route, request) &&
      params_match?(route, request) &&
      token_match?(request)
    end
  end
  
  def debug route, request
    puts "DEBUG: " + 
      [
        normalize_request_method(route['method']),
        normalize_request_method(request.request_method),
        route['params'],
        request.params,
        code,
        token_for(request)
      ].map(&:inspect).join(', ')
  end
  
  def method_match? route, request
    route_method = normalize_request_method(route['method'])
    request_method = normalize_request_method(request.request_method)

    route_method == request_method
  end
  
  def params_match? route, request
    route['params'].all? do |param, pattern|
      begin
        request.params[param].match?(pattern)
      rescue
        puts "REQUEST PARAMS: #{request.params.inspect}, #{param.inspect}"
        raise "failed"
      end
    end
  end
  
  def token_match? request
    code == token_for(request)
  end
  
  def normalize_request_method request_method
    request_method = request_method.to_s.downcase
    
    case request_method
    when 'patch'
      'put'
    else
      request_method
    end
  end
  
  def path_with_token label=nil, additional_params={}
    params = route_for(label)['params']
    params.merge!(additional_params) unless additional_params.empty?
    params.merge!(token: code)
    
    url_for(params)
  end

  def path_without_token label=nil, additional_params={}
    params = route_for(label)['params']
    params.merge!(additional_params) unless additional_params.empty?
    
    url_for(params)
  end

  private

  def generate_token
    until self.code.to_s =~ /^[0-9a-f]{16}$/ do
      temp_token = random_token
      self.code = temp_token unless self.class.where(code: temp_token).count > 0
    end
  end
  
  def set_expiration
    self.expires_at = 30.days.from_now if expires_at.nil?
  end
  
  def random_token
    Digest::MD5.hexdigest("#{Time.now}:#{rand}")[0,16]
  end
  
  def valid_routes_structure
    return set_invalid_routes_message unless routes.is_a?(Array)
    return errors.add(:routes, "requires at least one route") if routes.empty?
    
    routes.each do |route|
      return set_invalid_routes_message unless route.is_a?(Hash)
      return set_invalid_routes_message unless route.has_key?('method')
      return set_invalid_routes_message unless route.has_key?('params')
    end
  end
  
  def set_invalid_routes_message
    errors.add(:routes, invalid_routes_message) unless errors[:routes].include?(invalid_routes_message)
  end
  
  def invalid_routes_message
    "should be an array of hashes with keys 'method' and 'params'"
  end
  
  def token_for request
    request.params[:token] || request.session[:token]
  end
  
  def url_for params
    pattern_keys = params.keys.select{|k| params[k].is_a?(Regexp)}
    Rails.application.routes.url_helpers.url_for params.except(*pattern_keys)
  end
end
