require 'csv'

class MaterialImporter
  def self.create_material(row)
    new_material = Material.new(name: row[0], subcategories: [])
    add_subcategory(row, new_material)
  end

  def self.add_subcategory(row, material)
    subcategory_hash = {}

    subcategory_hash["id"]          = SecureRandom.uuid.gsub("-", "")
    subcategory_hash["name"]        = row[1]
    subcategory_hash["description"] = row[2]

    material.subcategories << subcategory_hash
    material.save
    material
  end

  def self.update_or_create_material(row)
    existing_material = Material.where(name: row[0]).last

    if existing_material
      add_subcategory(row, existing_material)
    else
      self.create_material(row)
    end
  end

  def self.get_all
    CSV.foreach('app/assets/materials_list.csv') do |row|
      result = update_or_create_material(row)
      puts result.name
    end
  end
end
