class CandidatesController < ApplicationController
  before_action :authenticate_user!
  
  def status
    if @fellow_opportunity = FellowOpportunity.find_by(id: params[:fellow_opportunity_id])
      update = params[:update].downcase
      notice = @fellow_opportunity.notice_for(update)
      
      @fellow_opportunity.update_stage(update, from: params[:from])
      
      flash[:stage_notice] = notice if notice

      redirect_to @fellow_opportunity.reload.active ?
        fellow_opportunity_path(@fellow_opportunity) :
        root_path
    else
      fail_token_authorize!
    end
  end
end
