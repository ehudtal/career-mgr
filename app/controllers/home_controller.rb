class HomeController < ApplicationController
  before_action :authenticate_user!
  
  def welcome
    case current_user.role
    when :admin
      redirect_to admin_home_welcome_path
    end
  end
end
