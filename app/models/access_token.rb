require 'digest/md5'
require 'uri'
require 'cgi'

class AccessToken < ApplicationRecord
  belongs_to :owner, polymorphic: true

  serialize :routes, JSON
  
  before_validation :generate_token

  validates :code, presence: true, uniqueness: true
  validate :valid_routes_structure
  
  class << self
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
        {label: 'view', method: 'GET', path: routes.admin_fellow_url(fellow)},
        {label: 'Edit Your Profile', method: 'GET', path: routes.edit_fellow_url(fellow)},
        {label: 'Update Your Profile', method: 'PUT', path: routes.fellow_url(fellow)}
      ]
    end
    
    def routes_for_fellow_opportunity fellow_opportunity
      allowed_statuses = [
       'Interested', 'Not Interested', 'Applying', 'Application Submitted', 
       'Interview Scheduled', 'Interview Completed', 
       'Offered', 'Accepted', 'Committed', 'Rejected' 
      ]
      
      allowed_statuses.map do |allowed_status|
        {label: allowed_status, method: 'GET', path: routes.candidate_status_url(fellow_opportunity.id, update: allowed_status)}
      end
    end
    
    def routes
      Rails.application.routes.url_helpers
    end
  end
  
  def route_for label=nil
    return routes.first if label.nil?
    routes.detect{|route| route['label'] == label}
  end
  
  def match? request
    routes.any? do |route|
      method_match?(route, request) &&
      route['path'] == url_without_token(request.original_url) &&
      code == token_for(request)
    end
  end
  
  def method_match? route, request
    route_method = normalize_request_method(route['method'])
    request_method = normalize_request_method(request.request_method)

    route_method == request_method
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
  
  def path_with_token label=nil
    route = route_for(label)
    
    uri = URI.parse(route['path'])
    
    new_query = URI.decode_www_form(uri.query || '') << ['token', code]
    uri.query = URI.encode_www_form(new_query)
    
    uri.to_s
  end

  private

  def generate_token
    until self.code.to_s =~ /^[0-9a-f]{16}$/ do
      temp_token = random_token
      self.code = temp_token unless self.class.where(code: temp_token).count > 0
    end
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
      return set_invalid_routes_message unless route.has_key?('path')
    end
  end
  
  def set_invalid_routes_message
    errors.add(:routes, invalid_routes_message) unless errors[:routes].include?(invalid_routes_message)
  end
  
  def invalid_routes_message
    "should be an array of hashes with keys 'method' and 'path'"
  end
  
  def url_without_token url
    uri = URI.parse(url)
    
    new_query = URI.decode_www_form(uri.query || '')
    new_query.reject!{|key, val| key == 'token'}
    
    uri.query = URI.encode_www_form(new_query)
    
    new_url = uri.to_s
    new_url.chop! if new_url =~ /\?$/
    
    new_url
  end
  
  def token_for request
    request.params[:token]
  end
end
