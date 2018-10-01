class Admin::IndustriesController < ApplicationController
  before_action :authenticate_user!, except: [:list, :combined]
  before_action :ensure_admin!, except: [:list, :combined]
  before_action :set_industry, only: [:show, :edit, :update, :destroy]

  # GET /industries
  # GET /industries.json
  def index
    @industries = Industry.order('name asc').all
  end
  
  def list
    @industries = Industry.order('name asc').all
    render layout: false
  end
  
  def combined
    @names = (Industry.pluck(:name) | Interest.pluck(:name)).sort
    
    respond_to do |format|
      format.html { render layout: false }
      format.json { render json: @names}
    end
  end

  # GET /industries/1
  # GET /industries/1.json
  def show
  end

  # GET /industries/new
  def new
    @industry = Industry.new
  end

  # GET /industries/1/edit
  def edit
  end

  # POST /industries
  # POST /industries.json
  def create
    @industry = Industry.new(industry_params)

    respond_to do |format|
      if @industry.save
        format.html { redirect_to admin_industries_path, notice: 'Industry was successfully created.' }
        format.json { render :show, status: :created, location: @industry }
      else
        format.html { render :new }
        format.json { render json: @industry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /industries/1
  # PATCH/PUT /industries/1.json
  def update
    respond_to do |format|
      if @industry.update(industry_params)
        format.html { redirect_to admin_industries_path, notice: 'Industry was successfully updated.' }
        format.json { render :show, status: :ok, location: @industry }
      else
        format.html { render :edit }
        format.json { render json: @industry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /industries/1
  # DELETE /industries/1.json
  def destroy
    industry_name = @industry.name
    
    @industry.destroy
    respond_to do |format|
      format.html { redirect_to admin_industries_url, notice: "Industry #{industry_name} was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_industry
      @industry = Industry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def industry_params
      params.require(:industry).permit(:name, :description)
    end
end
