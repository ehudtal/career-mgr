class Fellow::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_fellow!
  before_action :set_fellow, only: [:welcome, :career]
  
  def welcome
  end
  
  def career
    @fellow.completed_career_steps = params[:career_steps]
    # redirect_to fellow_home_welcome_path
  end
  
  def new_opportunity
    @employers = Employer.all
  end
end
