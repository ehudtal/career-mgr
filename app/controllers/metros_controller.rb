class MetrosController < ApplicationController

  # GET /metros.json
  def index
    @metros = Metro.order('name asc').all
  end
end
