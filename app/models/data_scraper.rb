class DataScraper
  def self.to_location(location_json)
    new_location = Location.new(
      name:          location_json['provider_name'],
      latitude:      location_json['geolocation']['latitude'],
      longitude:     location_json['geolocation']['longitude'],
      location_type: "Business"
    )

    new_location.contact_info = {
      street:  location_json['provider_address'],
      zipcode: location_json['zip'],
      phone:   location_json['phone']['phone_number'], 
      website: location_json['provider_url']['url']
    }

    new_location.misc_info = {
      hours:       location_json['hours'],       
      cost:        location_json['fee'],        
      min_volume:  location_json['minimum_volume'],
      max_volume:  location_json['maximum_volume'],  
      description: location_json['service_description'] + ' ' + location_json['restrictions']
    }

    new_location.pick_up   = location_json['pickup_allowed']   == 'TRUE'
    new_location.drop_off  = location_json['drop_off_allowed'] == 'TRUE'
    new_location.mail_in   = location_json['mail_in_allowed']  == 'TRUE'
    new_location.business  = location_json['property_type'].include?('Business')
    new_location.residents = location_json['property_type'].include?('Residents')

    new_location.save

    new_location
  end

  def self.get_all
    response = HTTParty.get('http://data.kingcounty.gov/resource/zqwi-c5q3.json')

    response.each do |location|
      puts location
      existing_location = Location.where(name: location['provider_name']).first

      if existing_location
        location['material_handled'].split(',').each do |material|
          puts existing_location.inspect
          existing_location.materials << material
        end
      else
        # new_location = Location.create(
        #   name:          location['provider_name'],
        #   latitude:      location['geolocation']['latitude'],
        #   longitude:     location['geolocation']['longitude'],    
        #   location_type: "Business"
        # )



        

        

        new_location.materials = []

        location['material_handled'].split(', ').each do |material|
          new_location.materials << material
        end

        new_location.save
      end
    end
  end
end
