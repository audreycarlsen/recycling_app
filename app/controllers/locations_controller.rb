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

    destination_coords = ""

    @mappable_locations.each do |location|
      unless location == @mappable_locations.last
        destination_coords << (location.latitude + "," + location.longitude + "|")
      else
        destination_coords << (location.latitude + "," + location.longitude)
      end
    end
    
    calculate_distances(params[:address], destination_coords)
  end

  # def get_coordinates
  #   response = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=1301+5th+Ave,+Seattle,+WA&sensor=true")
  # end

  private

  def calculate_distances(current_location, destination_coords)
    url = ("https://maps.googleapis.com/maps/api/distancematrix/json?origins=" + current_location + "&destinations=" + destination_coords + "&sensor=false&units=imperial").strip
    HTTParty.get(URI.encode(url))
  end

end
