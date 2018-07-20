class Admin::MetrosController < ApplicationController

  # GET /metros.json
  def index
    @metros = Metro.order('name asc').all
  end

  def list
    @metros = Metro.order('name asc').all
    render layout: false
  end
end
