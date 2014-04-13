class LocationsController < ApplicationController
  def index
    @displayed_address = params["displayed_address"].split("near: ").last
    @untouched_subcategories = params["subcategories"]
    parsed_subcategories = params["subcategories"].first.split(" ", 2)

    @subcategories = []

    if parsed_subcategories.first == "All"
      Material.where(name: parsed_subcategories.last).first.subcategories.each do |subcategory|
        @subcategories << subcategory["name"]
      end
    else
      @subcategories = params["subcategories"]
    end

    locations_by_material = Location.where(:materials.in => @subcategories)

    if params["type"] == "Business"
      @locations_by_type = locations_by_material.where(business: true)
    elsif params["type"] == "Residence"
      @locations_by_type = locations_by_material.where(residents: true)
    else
      @locations_by_type = locations_by_material
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

    @drop_off_locations = @drop_off_locations.reject{ |l| l.latitude.nil?}

    destination_coords = ""

    @drop_off_locations.each do |location|
      unless location == @drop_off_locations.last
        destination_coords << (location.latitude + "," + location.longitude + "|")
      else
        destination_coords << (location.latitude + "," + location.longitude)
      end
    end
  
    @distances = calculate_distances(params["address"], destination_coords)
    # @distances.parsed_response["rows"].first["elements"][index]["status"]

    @drop_off_locations.each_with_index do |location, index|
      location.distance = @distances.parsed_response["rows"].first["elements"][index]["distance"]["text"]
    end

    @drop_off_locations.sort_by! { |location| location.distance.split(" mi")[0].delete(",").to_f }
    @pick_up_locations.sort_by! { |location| location.name }
    @mail_in_locations.sort_by! { |location| location.name }

    # For jQuery map rendering
    @current_location = params["address"].split(",").map {|coord| coord.to_f}
  end

  private

  def calculate_distances(current_location, destination_coords)
    url = ("https://maps.googleapis.com/maps/api/distancematrix/json?origins=" + current_location + "&destinations=" + destination_coords + "&sensor=false&units=imperial&key=" + ENV['GOOGLE_SERVER_API_KEY']).strip
    HTTParty.get(URI.encode(url))
  end
end
