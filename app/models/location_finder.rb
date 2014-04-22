class LocationFinder
  def initialize(coordinates, subcategories, type)
    @subcategories = subcategories
    @coordinates = coordinates

    locations_by_material = Location.all_in(materials: @subcategories)

    if type == "Business"
      @locations_by_type = locations_by_material.where(business: true)
    elsif type == "Residence"
      @locations_by_type = locations_by_material.where(residents: true)
    else
      @locations_by_type = locations_by_material
    end
  end

  def drop_off_locations
    drop_off_locations = @locations_by_type.where(drop_off: true)
    drop_off_locations = drop_off_locations.reject{ |l| l.latitude.nil?}

    unless drop_off_locations.count == 0

      destination_coords = ""

      drop_off_locations.each do |location|
        unless location == drop_off_locations.last
          destination_coords << (location.latitude.to_s + "," + location.longitude.to_s + "|")
        else
          destination_coords << (location.latitude.to_s + "," + location.longitude.to_s)
        end
      end
    
      distances = LocationFinder.calculate_distances(@coordinates, destination_coords)

      if distances.include?("URI Too Large") || distances.parsed_response["rows"].first["elements"][0]["distance"] == nil
        drop_off_locations = nil
      else
        drop_off_locations.each_with_index do |location, index|
          location.distance = distances.parsed_response["rows"].first["elements"][index]["distance"]["text"]
        end
        drop_off_locations.sort_by! { |location| location.distance.split(" mi")[0].delete(",").to_f }
      end
    end

    drop_off_locations
  end

  def pick_up_locations
    pick_up_locations = @locations_by_type.where(pick_up: true)
    pick_up_locations.sort_by! { |location| location.name }
  end

  def mail_in_locations
    mail_in_locations = @locations_by_type.where(mail_in: true)
    mail_in_locations.sort_by! { |location| location.name }
  end

  def locations_by_type
    @locations_by_type
  end

  private

  def self.calculate_distances(current_location, destination_coords)
    url = ("https://maps.googleapis.com/maps/api/distancematrix/json?origins=" + current_location + "&destinations=" + destination_coords + "&sensor=false&units=imperial&key=" + ENV['GOOGLE_SERVER_API_KEY']).strip
    HTTParty.get(URI.encode(url))
  end
end