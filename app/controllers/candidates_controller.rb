class CandidatesController < ApplicationController
  before_action :authenticate_user!
  
  def status
    if @fellow_opportunity = FellowOpportunity.find_by(id: params[:fellow_opportunity_id])
      update = params[:update].downcase
      notice = @fellow_opportunity.opportunity_stage.content['notices'][update]
      
      @fellow_opportunity.update_stage(update, from: params[:from])
      
      flash[:stage_notice] = notice if notice
      redirect_to fellow_opportunity_path(@fellow_opportunity)
    else
      fail_token_authorize!
    end
  end
end
