class Admin::FellowOpportunitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_fellow_opportunity, only: [:show, :edit, :update, :destroy]

  # GET /fellow_opportunities
  # GET /fellow_opportunities.json
  def index
    @fellow_opportunities = FellowOpportunity.all
  end

  # GET /fellow_opportunities/1
  # GET /fellow_opportunities/1.json
  def show
  end

  # GET /fellow_opportunities/new
  def new
    @fellow_opportunity = FellowOpportunity.new
  end

  # GET /fellow_opportunities/1/edit
  def edit
  end

  # POST /fellow_opportunities
  # POST /fellow_opportunities.json
  def create
    @fellow_opportunity = FellowOpportunity.new(fellow_opportunity_params)

    respond_to do |format|
      if @fellow_opportunity.save
        format.html { redirect_to admin_fellow_opportunity_path(@fellow_opportunity), notice: 'Fellow opportunity was successfully created.' }
        format.json { render :show, status: :created, location: @fellow_opportunity }
      else
        format.html { render :new }
        format.json { render json: @fellow_opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fellow_opportunities/1
  # PATCH/PUT /fellow_opportunities/1.json
  def update
    respond_to do |format|
      if @fellow_opportunity.update(fellow_opportunity_params)
        format.html { redirect_to admin_fellow_opportunity_path(@fellow_opportunity), notice: 'Fellow opportunity was successfully updated.' }
        format.json { render :show, status: :ok, location: @fellow_opportunity }
      else
        format.html { render :edit }
        format.json { render json: @fellow_opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fellow_opportunities/1
  # DELETE /fellow_opportunities/1.json
  def destroy
    @fellow_opportunity.destroy
    respond_to do |format|
      format.html { redirect_to admin_fellow_opportunities_url, notice: 'Fellow opportunity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fellow_opportunity
      @fellow_opportunity = FellowOpportunity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fellow_opportunity_params
      params.require(:fellow_opportunity).permit(:secured_on, :staff_notes, :fellow_id, :opportunity_id, :opportunity_stage_id)
    end
end
