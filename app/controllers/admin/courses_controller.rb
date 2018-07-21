class Admin::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_site
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = @courses.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = @courses.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to admin_site_path(@course.site), notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to admin_site_path(@course.site), notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    site = @course.site
    
    @course.destroy
    respond_to do |format|
      format.html { redirect_to admin_site_url(site), notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
  def set_site
    @site = Site.find(params[:site_id]) if params[:site_id]
    @courses = @site ? @site.courses : Course.all
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = @courses.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def course_params
    params.require(:course).permit(:semester, :year, :site_id)
  end
end
