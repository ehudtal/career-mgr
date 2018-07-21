class Admin::LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_employer
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = @locations.build
    @location.build_contact
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = @locations.build(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to admin_location_path(@location), notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to admin_location_path(@location), notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    employer = @location.locateable
    @location.destroy

    respond_to do |format|
      format.html { redirect_to admin_employer_locations_url(employer), notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
  def set_employer
    @employer = Employer.find(params[:employer_id]) if params[:employer_id]
    @locations = @employer ? @employer.locations : Location.all
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = @locations.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def location_params
    params.require(:location).permit(
      :name, 
      contact_attributes: [:id, :address_1, :address_2, :city, :state, :postal_code, :phone, :email, :url]
    )
  end
end
