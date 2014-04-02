json.array! @locations do |location|
  if location.longitude
    json.type :Feature
    json.properties do
      json.name location.name
    end
    json.geometry do
      json.type :Point
      json.coordinates [location.longitude, location.latitude]
    end
  end
end