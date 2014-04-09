class DataScraper
  def self.create_location(location_json)
    new_location = Location.new(
      name:          location_json['provider_name'],
      latitude:      location_json['geolocation']['latitude'],
      longitude:     location_json['geolocation']['longitude'],
      location_type: "Business",
      street:        location_json['provider_address'],
      city:          location_json['city'],
      zipcode:       location_json['zip'],
      phone:         location_json['phone']['phone_number'], 
      website:       location_json['provider_url'].try(:[],'url'),
      hours:         location_json['hours'],       
      cost:          location_json['fee'],        
      min_volume:    location_json['minimum_volume'],
      max_volume:    location_json['maximum_volume'],  
      description:   (location_json['service_description'].to_s.strip + ' ' + location_json['restrictions'].to_s).strip
    )

    if location_json['zip']
      if location_json['zip'].to_i.between?(98001, 99403)
        new_location.state = "WA"
      else
        city_response = HTTParty.get('http://maps.googleapis.com/maps/api/geocode/json?address=' + location_json['zip'].to_s + '&sensor=false')
        city_response["results"][0]["address_components"].each do |hash|
          if hash["types"].include?("administrative_area_level_1")
            new_location.state = hash["short_name"]
          end
        end
      end
    elsif location_json["city"] && location_json["provider_address"]
      address = location_json['provider_address'].gsub(" ", "+") + "+" + location_json['city']
      url = 'http://maps.googleapis.com/maps/api/geocode/json?address=' + address + '&sensor=false'
      city_response = HTTParty.get(URI.encode(url))
      if city_response["results"][0]
        city_response["results"][0]["address_components"].each do |hash|
          if hash["types"].include?("administrative_area_level_1")
            new_location.state = hash["short_name"]
          end
          if hash["types"].include?("postal_code")
            new_location.zipcode = hash["short_name"]
          end
        end
      end
    end

    new_location.pick_up   = location_json['pickup_allowed']   == 'TRUE'
    new_location.drop_off  = location_json['dropoff_allowed'] == 'TRUE'
    new_location.mail_in   = location_json['mail_in_allowed']  == 'TRUE'
    new_location.business  = location_json['property_type'].include?('Business')
    new_location.residents = location_json['property_type'].include?('Residents')

    new_location.materials = []

    new_location.materials << location_json['material_handled']

    unless new_location.save
      Rails.logger.warning("#{new_location.name} failed")
    end

    new_location
  end

  def self.update_or_create_location(location_json)
    existing_location = Location.where(name: location_json['provider_name']).first

    if existing_location
      existing_location.materials << location_json['material_handled']
      existing_location.save
      existing_location
    else
      self.create_location(location_json)
    end
  end

  def self.get_all
    offset = 0
    while true
      response = HTTParty.get("http://data.kingcounty.gov/resource/zqwi-c5q3.json?$limit=1000&$offset=#{offset}")
      count = response.count
      offset += count

      response.each do |location_json|
        result = self.update_or_create_location(location_json)
        puts result.name
      end

      break if count < 1000
    end
  end
end
