require 'uri'

module ApplicationHelper
  def link_to_access_token access_token, label, options={}
    route = access_token.route_for(label)
    title = options.delete(:title) || route['label']
    token_url = access_token.path_with_token(label).html_safe
    
    link_to(title, token_url, options.merge(method: route['method'])).html_safe
  end
end
