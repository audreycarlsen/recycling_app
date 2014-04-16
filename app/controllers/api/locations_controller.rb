class Api::LocationsController < ApplicationController
  def index

    location_params = params.permit(:materials, :city, :state, :zipcode, :business,  :residents, :drop_off, :mail_in, :pick_up)

    @locations = Location.search(location_params)

    respond_to do |format|
      format.json { render :json => @locations }
    end
  end
end