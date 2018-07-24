class ApplicationController < ActionController::Base
  before_action :set_requested_redirect
  
  private
  
  def set_requested_redirect
    if params[:redirect]
      session[:requested_redirect] = params[:redirect]
    end
  end
  
  def follow_redirect
    requested_redirect = session.delete(:requested_redirect)
    
    case requested_redirect
    when 'new_opportunity'
      new_admin_employer_opportunity_path(@employer)
    else
      nil
    end
  end
  
  def ensure_admin!
    return if authorized_by_token?
    redirect_to(root_path) unless current_user.is_admin?
  end
  
  def ensure_fellow!
    return if authorized_by_token?
    redirect_to(root_path) unless current_user.is_fellow?
  end
  
  def authenticate_user!
    super unless authorized_by_token?
  end
  
  def authorized_by_token?
    return false unless params[:token]
    
    access_token = AccessToken.find_by code: params[:token]
    return false if access_token.nil?

    access_token.match?(request)
  end
end
