require 'custom_devise_sessions_controller'

class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:health_check, :login, :sso]
  
  def welcome
    case current_user.role
    when :admin
      redirect_to admin_home_welcome_path
    when :fellow
      redirect_to fellow_home_welcome_path
    end
  end
  
  def health_check
    User.count
    render inline: '200 OK'
  end
  
  def login
    flash[:alert] = nil
  end
  
  def sso
    session[:sso] = if params[:id] == 'nlu'
      Rails.application.secrets.nlu_sso_url
    else
      Rails.application.secrets.sso_url
    end
    
    redirect_to session.delete(:last)
  end
end
