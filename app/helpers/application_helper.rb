require 'uri'

module ApplicationHelper
  def link_to_access_token access_token, label, options={}
    route = access_token.route_for(label)
    title = options.delete(:title) || route['label']
    params = options.delete(:params) || {}
    token_url = access_token.path_with_token(label, params).html_safe
    
    link_to(title, token_url, options.merge(method: route['method'])).html_safe
  end
  
  def link_to_status_update from, update, title
    link_to_access_token(@token, 'status', title: title, params: {from: from, update: update}, class: 'button')
  end
end
