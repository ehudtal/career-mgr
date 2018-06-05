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
      new_employer_opportunity_path(@employer)
    else
      nil
    end
  end
end
