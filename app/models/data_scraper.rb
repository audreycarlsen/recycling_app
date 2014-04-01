class DataScraper
  def self.create_location(location_json)
    new_location = Location.new(
      name:          location_json['provider_name'],
      latitude:      location_json['geolocation']['latitude'],
      longitude:     location_json['geolocation']['longitude'],
      location_type: "Business",
      street:        location_json['provider_address'],
      zipcode:       location_json['zip'],
      phone:         location_json['phone']['phone_number'], 
      website:       location_json['provider_url'].try(:[],'url'),
      hours:         location_json['hours'],       
      cost:          location_json['fee'],        
      min_volume:    location_json['minimum_volume'],
      max_volume:    location_json['maximum_volume'],  
      description:   location_json['service_description'].to_s.strip + ' ' + location_json['restrictions'].to_s.strip
    )

    new_location.pick_up   = location_json['pickup_allowed']   == 'TRUE'
    new_location.drop_off  = location_json['drop_off_allowed'] == 'TRUE'
    new_location.mail_in   = location_json['mail_in_allowed']  == 'TRUE'
    new_location.business  = location_json['property_type'].include?('Business')
    new_location.residents = location_json['property_type'].include?('Residents')

    new_location.materials = []

    new_location.materials = new_location.materials + location_json['material_handled'].split(', ')

    new_location.save

    new_location
  end

  def self.update_or_create_location(location_json)
    existing_location = Location.where(name: location_json['provider_name']).first

    if existing_location
      existing_location.materials = existing_location.materials + location_json['material_handled'].split(', ')
      existing_location.save
      existing_location
    else
      self.create_location(location_json)
    end
  end

  def self.get_all
    response = HTTParty.get('http://data.kingcounty.gov/resource/zqwi-c5q3.json')

    response.each do |location_json|
      self.update_or_create_location(location_json)
    end
  end
end
