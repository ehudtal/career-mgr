class Admin::HomeController < ApplicationController
  before_action :authenticate_user!
  
  def welcome
  end
  
  def new_opportunity
    @employers = Employer.all
  end
end
