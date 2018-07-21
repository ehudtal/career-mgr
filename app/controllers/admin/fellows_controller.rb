class Admin::FellowsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_fellow, only: [:show, :edit, :update, :destroy]

  # GET /fellows
  # GET /fellows.json
  def index
    @fellows = Fellow.paginate(page: params[:page])
  end

  # GET /fellows/1
  # GET /fellows/1.json
  def show
  end

  # GET /fellows/new
  def new
    @fellow = Fellow.new
    @fellow.build_contact
  end

  # GET /fellows/1/edit
  def edit
    @fellow.build_contact if @fellow.contact.nil?
  end

  # POST /fellows
  # POST /fellows.json
  def create
    @fellow = Fellow.new(fellow_params)

    respond_to do |format|
      if @fellow.save
        format.html { redirect_to admin_fellows_path, notice: 'Fellow was successfully created.' }
        format.json { render :show, status: :created, location: @fellow }
      else
        format.html { render :new }
        format.json { render json: @fellow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fellows/1
  # PATCH/PUT /fellows/1.json
  def update
    respond_to do |format|
      if @fellow.update(fellow_params)
        format.html { redirect_to admin_fellows_path, notice: 'Fellow was successfully updated.' }
        format.json { render :show, status: :ok, location: @fellow }
      else
        format.html { render :edit }
        format.json { render json: @fellow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fellows/1
  # DELETE /fellows/1.json
  def destroy
    @fellow.destroy
    respond_to do |format|
      format.html { redirect_to admin_fellows_url, notice: 'Fellow was successfully deleted.' }
      format.json { head :no_content }
    end
  end
  
  def upload
    if params[:csv]
      Fellow.delay.import(csv) 

      flash[:notice] = 'Your file is being uploaded, thanks! You can refresh this page to see updates.'
      redirect_to admin_fellows_path
    end
  end

  private
  
  def csv
    if params[:csv].respond_to?(:read)
      params[:csv].read
    else
      params[:csv]
    end
  end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_fellow
      @fellow = Fellow.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fellow_params
      params.require(:fellow).permit(
        :key, :first_name, :last_name, :graduation_year, :graduation_semester, :graduation_fiscal_year, 
        :interests_description, :major, :affiliations, :gpa, :linkedin_url, :staff_notes, :efficacy_score, 
        :employment_status_id, :industry_tags, :interest_tags, :metro_tags,
        industry_ids: [], 
        interest_ids: [],
        metro_ids: [],
        contact_attributes: [:id, :address_1, :address_2, :city, :state, :postal_code, :phone, :email, :url]
      )
    end
end
