class Admin::EmploymentStatusesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_employment_status, only: [:show, :edit, :update, :destroy]

  # GET /employment_statuses
  # GET /employment_statuses.json
  def index
    @employment_statuses = EmploymentStatus.all
  end

  # GET /employment_statuses/1
  # GET /employment_statuses/1.json
  def show
  end

  # GET /employment_statuses/new
  def new
    @employment_status = EmploymentStatus.new
  end

  # GET /employment_statuses/1/edit
  def edit
  end

  # POST /employment_statuses
  # POST /employment_statuses.json
  def create
    @employment_status = EmploymentStatus.new(employment_status_params)

    respond_to do |format|
      if @employment_status.save
        format.html { redirect_to admin_employment_status_path(@employment_status), notice: 'Employment status was successfully created.' }
        format.json { render :show, status: :created, location: @employment_status }
      else
        format.html { render :new }
        format.json { render json: @employment_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employment_statuses/1
  # PATCH/PUT /employment_statuses/1.json
  def update
    respond_to do |format|
      if @employment_status.update(employment_status_params)
        format.html { redirect_to admin_employment_status_path(@employment_status), notice: 'Employment status was successfully updated.' }
        format.json { render :show, status: :ok, location: @employment_status }
      else
        format.html { render :edit }
        format.json { render json: @employment_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employment_statuses/1
  # DELETE /employment_statuses/1.json
  def destroy
    @employment_status.destroy
    respond_to do |format|
      format.html { redirect_to admin_employment_statuses_url, notice: 'Employment status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employment_status
      @employment_status = EmploymentStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employment_status_params
      params.require(:employment_status).permit(:name, :position)
    end
end
