class Admin::CohortFellowsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_cohort_fellow, only: [:show, :edit, :update, :destroy]

  # GET /cohort_fellows
  # GET /cohort_fellows.json
  def index
    @cohort_fellows = CohortFellow.all
  end

  # GET /cohort_fellows/1
  # GET /cohort_fellows/1.json
  def show
  end

  # GET /cohort_fellows/new
  def new
    @cohort_fellow = CohortFellow.new
  end

  # GET /cohort_fellows/1/edit
  def edit
  end

  # POST /cohort_fellows
  # POST /cohort_fellows.json
  def create
    @cohort_fellow = CohortFellow.new(cohort_fellow_params)

    respond_to do |format|
      if @cohort_fellow.save
        format.html { redirect_to admin_cohort_fellow_path(@cohort_fellow), notice: 'Cohort fellow was successfully created.' }
        format.json { render :show, status: :created, location: @cohort_fellow }
      else
        format.html { render :new }
        format.json { render json: @cohort_fellow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cohort_fellows/1
  # PATCH/PUT /cohort_fellows/1.json
  def update
    respond_to do |format|
      if @cohort_fellow.update(cohort_fellow_params)
        format.html { redirect_to admin_cohort_fellow_path(@cohort_fellow), notice: 'Cohort fellow was successfully updated.' }
        format.json { render :show, status: :ok, location: @cohort_fellow }
      else
        format.html { render :edit }
        format.json { render json: @cohort_fellow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cohort_fellows/1
  # DELETE /cohort_fellows/1.json
  def destroy
    @cohort_fellow.destroy
    respond_to do |format|
      format.html { redirect_to admin_cohort_fellows_url, notice: 'Cohort fellow was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cohort_fellow
      @cohort_fellow = CohortFellow.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cohort_fellow_params
      params.require(:cohort_fellow).permit(:grade, :attendance, :nps_response, :endorsement, :professionalism, :teamwork, :feedback, :fellow_id, :cohort_id)
    end
end
