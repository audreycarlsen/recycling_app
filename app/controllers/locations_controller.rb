class LocationsController < ApplicationController
  def index
    @subcategories = params["subcategories"]
    locations = Location.where(:materials.in => params["subcategories"])

    if params["type"] == "Business"
      locations_by_type = locations.where(business: true)
    elsif params["type"] == "Residence"
      locations_by_type = locations.where(residents: true)
    else
      locations_by_type = locations
    end

    if params["service"] == "pick_up"
      @locations_by_service_and_type = locations_by_type.where(pick_up: true)
    elsif params["service"] == "drop_off"
      @locations_by_service_and_type = locations_by_type.where(drop_off: true)
    elsif params["service"] == "mail_in"
      @locations_by_service_and_type = locations_by_type.where(mail_in: true)
    else
      @locations_by_service_and_type = locations_by_type
    end

    @mappable_locations = @locations_by_service_and_type.reject{ |l| l.latitude.nil? }

  end

  # def get_coordinates
  #   response = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=1301+5th+Ave,+Seattle,+WA&sensor=true")
  # end

  def calculate_distances
    response = HTTParty.get("https://maps.googleapis.com/maps/api/distancematrix/output?origins=" + current_location + "&destinations=" + locations + "&sensor=false")

    respond_to do |format|
      format.json { render json: response }
    end
  end
end
