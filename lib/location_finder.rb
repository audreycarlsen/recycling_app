class LocationFinder
  def initialize(coordinates, subcategories, type)
    @subcategories = subcategories

    locations_by_material = Location.all_in(materials: @subcategories)

    if type == "Business"
      @locations_by_type = locations_by_material.where(business: true)
    elsif type == "Residence"
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

    if @drop_off_locations != []

      destination_coords = ""

      @drop_off_locations.each do |location|
        unless location == @drop_off_locations.last
          destination_coords << (location.latitude + "," + location.longitude + "|")
        else
          destination_coords << (location.latitude + "," + location.longitude)
        end
      end
    
      @distances = calculate_distances(coordinates, destination_coords)

      if @distances.parsed_response["rows"].first["elements"][0]["distance"] == nil
        redirect_to root_path
      else
        @drop_off_locations.each_with_index do |location, index|
          location.distance = @distances.parsed_response["rows"].first["elements"][index]["distance"]["text"]
        end

        @drop_off_locations.sort_by! { |location| location.distance.split(" mi")[0].delete(",").to_f }
        @pick_up_locations.sort_by! { |location| location.name }
        @mail_in_locations.sort_by! { |location| location.name }

        # For jQuery map rendering
        @current_location = coordinates.split(",").map {|coord| coord.to_f}
      end
    end
  end

  def get_drop_off
  end

  def get_drop_off
  end

  def get_drop_off
  end
end