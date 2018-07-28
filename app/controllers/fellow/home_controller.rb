class Fellow::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_fellow!
  
  def welcome
    @fellow = current_user.fellow
  end
  
  def new_opportunity
    @employers = Employer.all
  end
end
