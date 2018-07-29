class CandidatesController < ApplicationController
  before_action :authorize_by_token!
  
  def status
    if @fellow_opportunity = FellowOpportunity.find_by(id: params[:fellow_opportunity_id])
      @fellow_opportunity.update_stage(params[:update].downcase, from: params[:from])
      redirect_to fellow_opportunity_path(@fellow_opportunity)
    else
      fail_token_authorize!
    end
  end
end
