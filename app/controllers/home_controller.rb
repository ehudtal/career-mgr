class HomeController < ApplicationController
  def welcome
  end
  
  def new_opportunity
    @employers = Employer.all
  end
end
