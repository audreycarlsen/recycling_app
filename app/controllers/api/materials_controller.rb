class Api::MaterialsController < ApplicationController
  def index
    @materials = Material.all

    respond_to do |format|
      format.json { render :json => @materials }
    end
  end
end