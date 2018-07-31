class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:health_check]
  
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
end
