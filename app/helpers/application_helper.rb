require 'uri'

module ApplicationHelper
  def link_to_access_token access_token, label
    route = access_token.route_for(label)
    
    uri = URI.parse(route['path'])
    new_query = URI.decode_www_form(uri.query || '') << ['token', access_token.code]
    uri.query = URI.encode_www_form(new_query)
    
    link_to route['label'], uri.to_s, method: route['method']
  end
end
