class Admin::OpportunityStagesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_opportunity_stage, only: [:show, :edit, :update, :destroy]

  # GET /opportunity_stages
  # GET /opportunity_stages.json
  def index
    @opportunity_stages = OpportunityStage.all
  end

  # GET /opportunity_stages/1
  # GET /opportunity_stages/1.json
  def show
  end

  # GET /opportunity_stages/new
  def new
    @opportunity_stage = OpportunityStage.new
  end

  # GET /opportunity_stages/1/edit
  def edit
  end

  # POST /opportunity_stages
  # POST /opportunity_stages.json
  def create
    @opportunity_stage = OpportunityStage.new(opportunity_stage_params)

    respond_to do |format|
      if @opportunity_stage.save
        format.html { redirect_to admin_opportunity_stage_path(@opportunity_stage), notice: 'Opportunity stage was successfully created.' }
        format.json { render :show, status: :created, location: @opportunity_stage }
      else
        format.html { render :new }
        format.json { render json: @opportunity_stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /opportunity_stages/1
  # PATCH/PUT /opportunity_stages/1.json
  def update
    respond_to do |format|
      if @opportunity_stage.update(opportunity_stage_params)
        format.html { redirect_to admin_opportunity_stage_path(@opportunity_stage), notice: 'Opportunity stage was successfully updated.' }
        format.json { render :show, status: :ok, location: @opportunity_stage }
      else
        format.html { render :edit }
        format.json { render json: @opportunity_stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /opportunity_stages/1
  # DELETE /opportunity_stages/1.json
  def destroy
    @opportunity_stage.destroy
    respond_to do |format|
      format.html { redirect_to admin_opportunity_stages_url, notice: 'Opportunity stage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_opportunity_stage
      @opportunity_stage = OpportunityStage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def opportunity_stage_params
      params.require(:opportunity_stage).permit(:name, :position, :probability)
    end
end
