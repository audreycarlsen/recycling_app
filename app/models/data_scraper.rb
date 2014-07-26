class DataScraper
  include Mongoid::Document

  field :date_modified, type: String

  def self.set_zip(location_json, new_location)
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

  def self.set_state(zipcode, new_location)
    if zipcode.length == 5
      if zipcode.to_i.between?(98001, 99403)
        new_location.state = "WA"
      else
        city_response = HTTParty.get('http://maps.googleapis.com/maps/api/geocode/json?address=' + zipcode.to_s + '&sensor=false')
        city_response["results"][0]["address_components"].each do |hash|
          if hash["types"].include?("administrative_area_level_1")
            new_location.state = hash["short_name"]
          end
        end
      end
    end
  end

  def self.set_materials(material_handled, new_location)
    new_location.materials = []
    new_location.materials << material_handled
  end

  def self.set_phone(phone, new_location)
    if phone == "()"
      new_location.phone = nil
    else
      new_location.phone = phone
    end
  end

  def self.set_services(location_json, new_location)
    new_location.pick_up   = location_json['pickup_allowed']  == 'TRUE'
    new_location.drop_off  = location_json['dropoff_allowed'] == 'TRUE'
    new_location.mail_in   = location_json['mail_in_allowed'] == 'TRUE'
    new_location.business  = location_json['property_type'].include?('Business')
    new_location.residents = location_json['property_type'].include?('Residents')
  end

  def self.set_programs(location_json, new_location)
    new_location.ecycle = location_json['ecycle'] == 'TRUE'
    new_location.tibn   = location_json['tibn']   == 'TRUE'
  end

  def self.set_state_and_zip(location_json, new_location)
    if location_json['zip']
      set_state(location_json['zip'], new_location)
    elsif location_json["city"] && location_json["provider_address"]
      set_zip(location_json, new_location)
    end
  end

  def self.add_new_material_and_description(existing_location, location_json)
    existing_location.materials << DataScraper.titleize(location_json['material_handled'])
    existing_location.description << (' ' + location_json['service_description'].to_s.strip + ' ' + location_json['restrictions'].to_s).strip
    existing_location.save
    existing_location
  end

  def self.create_location(location_json)
    new_location = Location.new(
      name:          DataScraper.titleize(location_json['provider_name']),
      latitude:      location_json['geolocation']['latitude'].to_f.round(4),
      longitude:     location_json['geolocation']['longitude'].to_f.round(4),
      location_type: "Business",
      street:        location_json['provider_address'],
      city:          location_json['city'],
      zipcode:       location_json['zip'],
      website:       location_json['provider_url'].try(:[],'url'),
      hours:         location_json['hours'],       
      cost:          location_json['fee'],        
      min_volume:    location_json['minimum_volume'],
      max_volume:    location_json['maximum_volume'],  
      description:   (location_json['service_description'].to_s.strip + ' ' + location_json['restrictions'].to_s).strip,
    )

    set_state_and_zip(location_json, new_location)
    set_services(location_json, new_location)
    set_programs(location_json, new_location)
    set_materials(location_json['material_handled'], new_location)
    set_phone(location_json['phone']['phone_number'], new_location)

    unless new_location.save
      Rails.logger.warning("#{new_location.name} failed")
    end

    new_location
  end

  def self.needs_updating?(api_date_modified)
    api_date_modified != DataScraper.last.date_modified
  end

  def self.socrata_api_call(offset = 0)
    HTTParty.get("http://data.kingcounty.gov/resource/zqwi-c5q3.json?$limit=1000&$offset=#{offset}")
  end

  def self.update_or_create_location(location_json)
    existing_location = Location.where(name: DataScraper.titleize(location_json['provider_name'])).first

    if existing_location
      add_new_material_and_description(existing_location, location_json)
    else
      create_location(location_json)
    end
  end

  def self.update_date_modified(api_date_modified)
    ds = DataScraper.last
    ds.date_modified = api_date_modified
    ds.save
  end

  def self.update_or_leave_locations_alone(api_date_modified)
    if needs_updating?(api_date_modified)

      Location.delete_all

      offset = 0

      while true
        response = socrata_api_call(offset)
        count = response.count
        offset += count

        response.each do |location_json|
          result = self.update_or_create_location(location_json)
          puts result.name
        end

        break if count < 1000
      end

      update_date_modified(api_date_modified)
    end
  end

  def self.get_all
    unless DataScraper.last
      DataScraper.create
    end

    test_response = HTTParty.get("http://data.kingcounty.gov/resource/zqwi-c5q3.json?$limit=1")
    last_date_modified = test_response.headers["last-modified"]
    self.update_or_leave_locations_alone(last_date_modified)
  end

  def self.titleize(name)
    lowercase_words = %w{a an the and but or for nor of}
    title = name.split.each_with_index.map do |x, index| 
      unless /[[:upper:]]/.match(x[1])
        lowercase_words.include?(x) && index > 0 ? x : x.capitalize
      else
        x
      end
    end
    title.join(" ")
  end
end
