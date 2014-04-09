json.array! @mappable_locations do |location|
  if location.longitude
    json.name      location.name
    json.website   location.website
    json.street    location.street
    json.city      location.city
    json.zipcode   location.zipcode
    json.phone     location.phone
    json.hours     location.hours
    json.latitude  location.latitude
    json.longitude location.longitude
    json.distance  location.distance
  end
end