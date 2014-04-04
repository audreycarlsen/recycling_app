class MaterialsController < ApplicationController
  def show
    material_result = Material.find(params[:id])

    respond_to do |format|
      format.json { render json: material_result}
    end
  end
end
