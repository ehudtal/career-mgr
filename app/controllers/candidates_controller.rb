class CandidatesController < ApplicationController
  before_action :set_opportunity
  before_action :set_fellow_opportunity, only: [:update, :destroy]
  
  def index
    @candidates = @opportunity.candidates(params[:search])
    
    params[:search] ||= {}
    params[:search][:interests] ||= @opportunity.interest_tags
    params[:search][:industries] ||= @opportunity.industry_tags
    params[:search][:metros] ||= @opportunity.metro_tags
  end

  def create
    @opportunity.candidate_ids = params[:candidate_ids]
    
    redirect_to opportunity_path(@opportunity), notice: "#{params[:candidate_ids].size} candidates have been notified."
  end
  
  def update
    respond_to do |format|
      if @fellow_opportunity.update(fellow_opportunity_params)
        format.html { redirect_to @fellow_opportunity.opportunity, notice: 'Candidate info was successfully updated.' }
        format.json { render :show, status: :ok, location: @fellow_opportunity }
      else
        format.html { render :edit }
        format.json { render json: @fellow_opportunity.errors, status: :unprocessable_entity }
      end
    end
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
  
  def fellow_opportunity_params
    params.require(:fellow_opportunity).permit(:id, :opportunity_stage_id)
  end
end
