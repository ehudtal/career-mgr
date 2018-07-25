class Admin::MetrosController < ApplicationController
  before_action :authenticate_user!, except: [:list]
  before_action :ensure_admin!, except: [:list]

  # GET /metros.json
  def index
    @metros = Metro.order('name asc').all
  end

  def list
    @metros = Metro.order('name asc').all
    render layout: false
  end
end
