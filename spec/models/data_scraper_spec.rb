require 'spec_helper'

describe DataScraper do
  describe "location_json" do
    it "returns a Location instance" do
      expect(DataScraper.to_location(location_json).class).to eq(Location)
    end

    it "saves provider name" do
      expect(DataScraper.to_location(location_json).name).to eq("1 Green Planet")
    end

    it "saves zipcode within contact_info" do
      expect(DataScraper.to_location(location_json).contact_info.zipcode).to eq("98057")
    end

    it "saves description and restrictions together in misc_info" do
      expect(DataScraper.to_location(location_json).misc_info.description).to eq("Anything with a cord on or anything with metal in it. Working or not or parts. Pickup service available upon arragement, typically for quantity of ten items or more.  Please inquire. Call to arrange drop off.")
    end

    it "saves pick_up" do
      expect(DataScraper.to_location(location_json).pick_up).to eq(true)
    end

    it "saves business" do
      expect(DataScraper.to_location(location_json).business).to eq(true)
    end
  end

  describe "get_all" do


    it "saves data to mongo correctly" do
      expect(Location.last).to eq{}
    end

    
  end
end

def location_json
  {"zip"=>"98057", "maximum_volume"=>"no maximum", "phone"=>{"phone_number"=>"(425) 996-3513"}, "providerid"=>"710", "restrictions"=>"Pickup service available upon arragement, typically for quantity of ten items or more.  Please inquire. Call to arrange drop off.", "location"=>"850 SW 7th St. WA 98057", "dropoff_allowed"=>"TRUE", "hours"=>"Mon - Fri:  9:30am - 6:30pm", "pickup_allowed"=>"TRUE", "city"=>"Renton", "material_handled"=>"Air Conditioners, Heat Pumps", "fee"=>"We provide free recycling to everyone !", "mapping_location"=>{"needs_recoding"=>false, "longitude"=>"-122.22809200647511", "latitude"=>"47.473790760173145", "human_address"=>"{\"address\":\"850 7th St\",\"city\":\"WA\",\"state\":\"\",\"zip\":\"98057\"}"}, "property_type"=>"Business, Residents", "geolocation"=>{"needs_recoding"=>false, "longitude"=>"-122.22763688128907", "latitude"=>"47.473764549319185", "human_address"=>"{\"address\":\"850 SW 7th St.\",\"city\":\"Renton\",\"state\":\"\",\"zip\":\"98057\"}"}, "minimum_volume"=>"no minimum", "mail_in_allowed"=>"TRUE", "service_description"=>"Anything with a cord on or anything with metal in it. Working or not or parts.", "provider_url"=>{"url"=>"http://1greenplanet.org"}, "provider_address"=>"850 SW 7th St.", "provider_name"=>"1 Green Planet"}
end