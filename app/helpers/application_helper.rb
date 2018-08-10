require 'uri'
require 'erb'

module ApplicationHelper
  def link_to_access_token access_token, label, options={}
    route = access_token.route_for(label)
    title = options.delete(:title) || route['label']
    skip_token = options.delete(:skip_token)
    params = options.delete(:params) || {}

    token_url = skip_token ?
      access_token.path_without_token(label, params).html_safe :
      access_token.path_with_token(label, params).html_safe
    
    link_to(title, token_url, options.merge(method: route['method'])).html_safe
  end
  
  def link_to_status_update update, title
    link_to_access_token(@token, 'status', title: title, skip_token: true, params: {update: update})
  end
  
  def button_to_status_update from, update, title
    link_to_access_token(@token, 'status', title: title, params: {from: from, update: update}, class: 'button')
  end
  
  def interpolate string
    ERB.new(string || '').result(binding)
  end
  
  def split_list list
    sorted_list = list.uniq.sort
    half = (sorted_list.size.to_f / 2).round

    [sorted_list[0...half], sorted_list[half..-1]]
  end
end
