require 'digest/md5'

class AccessToken < ApplicationRecord
  serialize :routes, JSON
  
  before_validation :generate_token

  validates :code, presence: true, uniqueness: true
  validate :valid_routes_structure
  
  class << self
    def fellow_dashboard_view fellow
      create routes: [
        {label: 'view', method: 'GET', path: routes.admin_fellow_path(fellow)}
      ]
    end
    
    def routes
      Rails.application.routes.url_helpers
    end
  end
  
  def route_for label
    routes.detect{|route| route['label'] == label}
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
end
