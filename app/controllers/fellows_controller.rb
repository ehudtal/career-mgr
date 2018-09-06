class FellowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fellow

  def edit
    @fellow.build_contact if @fellow.contact.nil?
  end

  def update
    unless @fellow.update(fellow_params)
      render :edit
    end
  end

  private
  
  def set_fellow
    @fellow = Fellow.find(params[:id])
  end

  def fellow_params
    params.require(:fellow).permit(
      :key, :first_name, :last_name, :graduation_year, :graduation_semester, :graduation_fiscal_year, 
      :interests_description, :major, :affiliations, :gpa, :linkedin_url, :staff_notes, :efficacy_score, 
      :employment_status_id, :industry_tags, :interest_tags, :metro_tags, :industry_interest_tags,
      industry_ids: [], 
      interest_ids: [],
      metro_ids: [],
      contact_attributes: [:id, :address_1, :address_2, :city, :state, :postal_code, :phone, :email, :url]
    )
  end
end
