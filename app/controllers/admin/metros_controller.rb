class Admin::MetrosController < ApplicationController
  before_action :authenticate_user!, except: [:list, :search]
  before_action :ensure_admin!, except: [:list, :search]

  # GET /metros.json
  def index
    @metros = Metro.order('name asc').all
  end

  def list
    @metros = Metro.order('name asc').all
    render layout: false
  end
  
  def search
    respond_to do |format|
      format.json do
        if postal_code = PostalCode.find_by(code: params[:zip])
          render json: postal_code.metro.as_json 
        else
          render json: nil
        end
      end
    end
  end
end
