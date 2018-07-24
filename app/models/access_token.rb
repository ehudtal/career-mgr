require 'digest/md5'
require 'uri'
require 'cgi'

class AccessToken < ApplicationRecord
  serialize :routes, JSON
  
  before_validation :generate_token

  validates :code, presence: true, uniqueness: true
  validate :valid_routes_structure
  
  class << self
    def fellow_dashboard_view fellow
      create routes: [
        {label: 'view', method: 'GET', path: routes.admin_fellow_url(fellow)}
      ]
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
      route['method'].to_s.downcase == request.request_method.downcase &&
      route['path'] == url_without_token(request.original_url) &&
      code == token_for(request.original_url)
    end
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
    
    new_query = URI.decode_www_form(uri.query)
    new_query.reject!{|key, val| key == 'token'}
    
    uri.query = URI.encode_www_form(new_query)
    
    new_url = uri.to_s
    new_url.chop! if new_url =~ /\?$/
    
    new_url
  end
  
  def token_for url
    uri = URI.parse(url)
    token_param = CGI.parse(uri.query)['token']
    
    return nil if token_param.nil?
    token_param.first
  end
end
