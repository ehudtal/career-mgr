class Admin::OpportunitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_employer
  before_action :set_opportunity, only: [:show, :edit, :update, :destroy]

  # GET /opportunities
  # GET /opportunities.json
  def index
  end
  
  def export
    respond_to do |format|
      format.csv do
        @opportunities = unpaginated_opportunities
        Rails.logger.info("OPPS: #{@opportunities.inspect}")
        Opportunity.where(id: @opportunities.map(&:id)).update_all(published: true)
    
        headers['Content-Disposition'] = "attachment; filename=\"opportunities.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  # GET /opportunities/1
  # GET /opportunities/1.json
  def show
  end

  # GET /opportunities/new
  def new
    @opportunity = @opportunities.build
    @opportunity.tasks.build
  end

  # GET /opportunities/1/edit
  def edit
    @opportunity.tasks.build
  end

  # POST /opportunities
  # POST /opportunities.json
  def create
    @opportunity = @opportunities.build(opportunity_params)

    respond_to do |format|
      if @opportunity.save
        format.html { redirect_to admin_employer_opportunities_path(@opportunity.employer), notice: 'Opportunity was successfully created.' }
        format.json { render :show, status: :created, location: @opportunity }
      else
        format.html { render :new }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /opportunities/1
  # PATCH/PUT /opportunities/1.json
  def update
    respond_to do |format|
      if @opportunity.update(opportunity_params)
        format.html { redirect_to admin_employer_opportunities_path(@opportunity.employer), notice: 'Opportunity was successfully updated.' }
        format.json { render :show, status: :ok, location: @opportunity }
      else
        format.html { render :edit }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /opportunities/1
  # DELETE /opportunities/1.json
  def destroy
    employer = @opportunity.employer
    @opportunity.destroy

    respond_to do |format|
      format.html { redirect_to admin_employer_opportunities_url(employer), notice: 'Opportunity was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
  
  def set_employer
    @employer = Employer.find(params[:employer_id]) if params[:employer_id]
    @opportunities = (@employer ? @employer.opportunities : Opportunity).paginate(page: params[:page])
  end
  
  def unpaginated_opportunities
    (@employer ? @employer.opportunities : Opportunity).where(id: params[:export_ids]).sort_by(&:priority).sort_by{|o| o.region.position}
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def set_opportunity
    @opportunity = @opportunities.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def opportunity_params
    params.require(:opportunity).permit(
      :_destroy,
      :name, :description, :employer_id, :job_posting_url, :application_deadline, 
      :inbound, :recurring, :opportunity_type_id, :region_id,
      :industry_tags, :interest_tags, :metro_tags, :industry_interest_tags,
      industry_ids: [], 
      interest_ids: [],
      steps: [],
      metro_ids: [],
      location_ids: [],
      locations_attributes: [
        :_destroy, :id, :name, :locateable_id, :locateable_type,
        contact_attributes: [:id, :address_1, :address_2, :city, :state, :postal_code, :phone, :email, :url]
      ]
    )
  end
end
