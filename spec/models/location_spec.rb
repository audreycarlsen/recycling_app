require 'spec_helper'

describe Location do
  before do
    Location.create(
      name:      'Location 1',
      business:  true,
      city:      "Seattle",
      drop_off:  true,
      mail_in:   true,
      materials: ["Gaming Devices","Printers"],
      pick_up:   true,
      residents: true,
      state:     "WA",
      zipcode:   "98108")

    Location.create(
      name:      'Location 2',
      business:  true,
      city:      "Renton",
      drop_off:  true,
      mail_in:   true,
      materials: ["Air Conditioners, Heat Pumps","Other Major Appliances"],
      pick_up:   true,
      residents: true,
      state:     "WA",
      zipcode:   "98057")
  end

  describe "search" do
    it "returns locations with matching params" do
      expect(Location.search(location_params1).count).to eq(1)
      expect(Location.search(location_params1).last.name).to eq('Location 2')
    end

    it "does not return locations without matching params" do
      expect(Location.search(location_params2).count).to eq(0)
    end

    it "returns locations that have matching materials" do
      expect(Location.search(location_params3).last.name).to eq('Location 1')
    end

    it "only returns locations that have all matching materials" do
      expect(Location.search(location_params4).count).to eq(0)
    end
  end
end

def location_params1
  {"zipcode"=>"98057", "residents"=>true, "business"=>true}
end

def location_params2
  {"zipcode"=>"98057", "residents"=>false, "business"=>true}
end

def location_params3
  {"materials"=>"Gaming+Devices,Printers"}
end

def location_params4
  {"materials"=>"Gaming+Devices,Bunnies"}
end