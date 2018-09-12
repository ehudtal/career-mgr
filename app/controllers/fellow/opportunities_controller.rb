class Fellow::OpportunitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_fellow!
  before_action :set_fellow
  before_action :set_candidate

  def show
    @content = YAML.load(File.read("#{Rails.root}/config/opportunity_stage_content.yml"))

    @fellow_opp = @candidate
    @fellow = @fellow_opp.fellow
    @opportunity = @fellow_opp.opportunity
    
    @token = AccessToken.for(@fellow_opp)
    @opportunity_stage = @fellow_opp.opportunity_stage
  end

  def update
    # if @fellow.update(fellow_params)
    #   redirect_to fellow_profile_path, notice: 'Your profile was successfully updated.'
    # else
    #   render :edit
    # end
  end
  
  private
  
  def set_fellow
    if @access_token
      @fellow = @access_token.owner.fellow
      return
    end
    
    unless current_user.fellow
      current_user.create_fellow(
        first_name: 'unknown',
        last_name: 'unknown',
        employment_status: EmploymentStatus.find_by(position: 0)
      )
    end
    
    @fellow = current_user.fellow
  end
  
  def set_candidate
    @candidate = @fellow.fellow_opportunities.find_by(id: params[:id])
  end
  
  def fellow_params
    # params.require(:fellow).permit(
    #   :key, :first_name, :last_name, :graduation_year, :graduation_semester,
    #   :major, :affiliations, :linkedin_url,
    #   :employment_status_id, :industry_tags, :interest_tags, :metro_tags, :industry_interest_tags,
    #   industry_ids: [], interest_ids: [], metro_ids: [],
    #   contact_attributes: [:id, :address_1, :address_2, :city, :state, :postal_code, :phone, :email, :url]
    # )
  end
end
