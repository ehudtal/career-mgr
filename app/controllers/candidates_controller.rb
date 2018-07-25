class CandidatesController < ApplicationController
  before_action :authorize_by_token!
  
  def status
    if @fellow_opportunity = FellowOpportunity.find_by(id: params[:fellow_opportunity_id])
      @fellow_opportunity.stage = params[:update].downcase
    else
      fail_token_authorize!
    end
  end
end
