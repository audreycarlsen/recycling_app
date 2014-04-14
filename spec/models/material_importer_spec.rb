require 'spec_helper'

describe MaterialImporter do
  describe "create_material" do
    it "returns a Material instance" do
      expect(MaterialImporter.create_material(csv_row).class).to eq(Material)
    end

    it "saves material name" do
      expect(MaterialImporter.create_material(csv_row).name).to eq("Animal Waste")
    end

    it "saves subcategory properly" do
      expect(MaterialImporter.create_material(csv_row).subcategories).to eq([{"name" => "Animal Manure, Excrement", "description" => "Animal and pet feces (poop) or manure."}])
    end
  end

  describe "add_subcategory" do
    it "returns a Material instance" do
      expect(MaterialImporter.add_subcategory(csv_row2, material).class).to eq(Material)
    end

    it "adds subcategory and description to subcategories array" do
      expect(MaterialImporter.add_subcategory(csv_row2, material).subcategories).to eq([{"name" => "Animal Manure, Excrement", "description" => "Animal and pet feces (poop) or manure."}, {"name" => "Dead Animals", "description" => "Dead pets, farm animals or wildlife."}])
    end
  end
end

def csv_row
  ["Animal Waste","Animal Manure, Excrement","Animal and pet feces (poop) or manure."]
end

def csv_row2
  ["Animal Waste","Dead Animals","Dead pets, farm animals or wildlife."]
end

def material
  Material.create(name: "Animal Waste", subcategories: [{"name"=> "Animal Manure, Excrement", "description" => "Animal and pet feces (poop) or manure."}])
end