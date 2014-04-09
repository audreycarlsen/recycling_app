class LocationsController < ApplicationController
  def index
    @subcategories = params["subcategories"]
    locations = Location.where(:materials.in => params["subcategories"])

    if params["type"] == "Business"
      @locations_by_type = locations.where(business: true)
    elsif params["type"] == "Residence"
      @locations_by_type = locations.where(residents: true)
    else
      @locations_by_type = locations
    end

    @pick_up_locations  = []
    @drop_off_locations = []
    @mail_in_locations  = []

    @locations_by_type.each do |location|
      if location.pick_up == true
        @pick_up_locations << location
      end
      if location.drop_off == true
        @drop_off_locations << location
      end
      if location.mail_in == true
        @mail_in_locations << location
      end
    end

    # Only want map to display locations that have an address and accept drop-offs:
    @mappable_locations = @locations_by_type.reject{ |l| l.latitude.nil? || l.drop_off == false }

    destination_coords = ""

    @mappable_locations.each do |location|
      unless location == @mappable_locations.last
        destination_coords << (location.latitude + "," + location.longitude + "|")
      else
        destination_coords << (location.latitude + "," + location.longitude)
      end
    end
    
    @distances = calculate_distances(params[:address], destination_coords)

    @mappable_locations.each_with_index do |location, index|
      location.distance = @distances.parsed_response["rows"].first["elements"][index]["distance"]["text"]
    end

    # @locations_by_service_and_type.each_with_index do |location, index|
    #   next if location.latitude
    #   location.distance = @distances.parsed_response["rows"].first["elements"][index]["distance"]["text"]
    # end

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
