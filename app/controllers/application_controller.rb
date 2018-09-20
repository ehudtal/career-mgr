require 'csv'

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
  
  def set_fellow
    unless current_user.fellow
      current_user.create_fellow(
        first_name: 'unknown',
        last_name: 'unknown',
        employment_status: EmploymentStatus.find_by(position: 0)
      )
    end
    
    @fellow = current_user.fellow
  end
  
  def authenticate_user!
    unless authorized_by_token?
      session[:last] = request.fullpath
      super
    end
  end
  
  def authorized_by_token?
    token_code = params[:token] || session[:token]
    return false unless token_code
    
    access_token = AccessToken.find_by code: token_code
    return false if access_token.nil?

    if access_token.match?(request)
      session[:token] = token_code
      @access_token = access_token
      
      true
    else
      false
    end
  end
end
