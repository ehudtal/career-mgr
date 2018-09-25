class Admin::MajorsController < ApplicationController
  before_action :authenticate_user!, except: [:list]
  before_action :ensure_admin!, except: [:list]

  # GET /majors.json
  def index
    @majors = Major.order('name asc').all
  end

  def list
    @majors = Major.order('name asc').all
    render layout: false
  end
end
