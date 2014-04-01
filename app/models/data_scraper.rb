class DataScraper
  def self.get_all
    response = HTTParty.get('http://data.kingcounty.gov/resource/zqwi-c5q3.json')
    response.each do |location|
      new_location = Location.new(
        name:          location['provider_name'],
        street:        location['provider_address'],
        zipcode:       location['zip'],
        latitude:      location['geolocation']['latitude'],
        longitude:     location['geolocation']['longitude'],   
        phone:         location['phone']['phone_number'],       
        hours:         location['hours'],       
        cost:          location['fee'],        
        website:       location['provider_url']['url'],     
        min_volume:    location['minimum_volume'],
        max_volume:    location['maximum_volume'],  
        description:   location['service_description'] + '' + location['restrictions'], 
        location_type: "Business"
      )

      new_location.pick_up?   = location['pickup_allowed']   == 'TRUE'
      new_location.drop_off?  = location['drop_off_allowed'] == 'TRUE'
      new_location.mail_in?   = location['mail_in_allowed']  == 'TRUE'
      new_location.business?  = location['property_type'].include?('Business')
      new_location.residents? = location['property_type'].include?('Residents')

      # materials: location['material_handled'],   
    end
  end
end
