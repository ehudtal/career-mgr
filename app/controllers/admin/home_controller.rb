class Admin::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  
  def welcome
  end
  
  def new_opportunity
    @employers = Employer.all
  end
end
