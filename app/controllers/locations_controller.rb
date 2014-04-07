class LocationsController < ApplicationController
  def index
    @subcategories = params["subcategories"]
    @locations = Location.where(:materials.in => params["subcategories"])

    # TO DO: Look up these addresses by hand?! :(
    @bad_locations = Location.all.where(latitude: nil)
  end

  # def get_coordinates
  #   response = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=1301+5th+Ave,+Seattle,+WA&sensor=true")
  # end
end
