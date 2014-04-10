json.drop_off_locations do
  json.array! @drop_off_locations do |location|
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
json.current_location do
  json.latitude  @current_location[0]
  json.longitude @current_location[1]
end