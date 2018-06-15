class CandidatesController < ApplicationController
  before_action :set_opportunity
  before_action :set_fellow_opportunity, only: [:destroy]
  
  def index
    @candidates = @opportunity.candidates
  end

  def create
    @opportunity.candidate_ids = params[:candidate_ids]
    
    redirect_to opportunity_path(@opportunity), notice: "#{params[:candidate_ids].size} candidates have been notified."
  end
  
  def destroy
    opportunity = @fellow_opportunity.opportunity
    @fellow_opportunity.destroy
    
    respond_to do |format|
      format.html { redirect_to opportunity_url(opportunity), notice: 'Candidate was successfully archived.' }
      format.json { head :no_content }
    end
  end
  
  private
  
  def set_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
    @fellow_opportunities = @opportunity ? @opportunity.fellow_opportunities : FellowOpportunity.all
  end
  
  def set_fellow_opportunity
    @fellow_opportunity = @fellow_opportunities.find(params[:id])
  end
end
