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
  
  def link_to_unsubscribe fellow
    link_to('Unsubscribe', AccessToken.for(fellow).path_with_token('Unsubscribe')).html_safe
  end
  
  def interpolate string
    ERB.new(string || '').result(binding).html_safe
  end
  
  def split_list list
    sorted_list = list.uniq.sort
    half = (sorted_list.size.to_f / 2).round

    [sorted_list[0...half], sorted_list[half..-1]]
  end
  
  def nearest_distance fellow, postal_codes
    distance = fellow.nearest_distance(postal_codes)
    distance ? pluralize(distance.round, 'mile') : 'N/A'
  end
  
  def sso_encode
    URI.encode("#{request.base_url}/users/service", /[^\-_!~*'()a-zA-Z\d;?@&=+$,\[\]]/)
  end
  
  def braven_login
    "#{Rails.application.secrets.sso_url}login?service=#{sso_encode}"
  end
  
  def nlu_login
    "#{Rails.application.secrets.nlu_sso_url}login?service=#{sso_encode}"
  end
  
  def checkmark boolean
    boolean ? '&#x2714;'.html_safe : ''
  end
  
  def paragraph_format text
    cleaned_text = text.gsub(/\r/, '').gsub(/\n+/, '</p><p>')
    "<p>#{cleaned_text}</p>".html_safe
  end
  
  def address_parts contact
    parts = []
    
    parts << contact.address_1 if contact.address_1.present?
    parts << contact.address_2 if contact.address_2.present?
    
    city_state_zip = ''
    city_state_zip += contact.city if contact.city.present?
    city_state_zip += ", " if contact.city.present? && contact.state.present?
    city_state_zip += contact.state if contact.state.present?
    city_state_zip += ' ' if (contact.city.present? || contact.state.present?) && contact.postal_code.present?
    city_state_zip += contact.postal_code if contact.postal_code.present?
    
    parts << city_state_zip if city_state_zip.present?

    parts
  end
  
  def address_for contact
    address_parts(contact).join('<br>').html_safe
  end
  
  def resume_link fellow
    if !fellow.respond_to?(:resume)
      ''
    elsif fellow.resume.attached?
      link_to('view', url_for(fellow.resume), target: '_blank').html_safe
    elsif fellow.attributes['resume_url']
      link_to('view', fellow.resume_url, target: '_blank').html_safe
    else
      "<div class=\"fellow-resume-url faded\" data-fellow=\"#{fellow.id}\">searching...</div>".html_safe
    end
  end
end
