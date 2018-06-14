class CandidatesController < ApplicationController
  before_action :set_opportunity
  
  def index
    @candidates = @opportunity.candidates
  end

  def create
    redirect_to opportunity_path(@opportunity)
  end
  
  private
  
  def set_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end
end
