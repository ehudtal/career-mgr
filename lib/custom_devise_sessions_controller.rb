require 'uri'

Devise::CasSessionsController.class_eval do
  def new
    if session[:sso]
      service = URI.encode("#{request.base_url}/users/service", /[^\-_!~*'()a-zA-Z\d;?@&=+$,\[\]]/)
      sso_url = session[:sso]

      url="#{sso_url}login?service=#{service}"
      Rails.logger.info("SSO_URL: #{url}")

      redirect_to url
    else
      redirect_to login_path
    end
  end
end
