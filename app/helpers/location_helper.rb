module LocationHelper
  def display_descriptions_for(location, materials)
    description = ""
    materials.each do |material|
      description << location.description[material]
    end
    description = "(none)" if description.empty?
    description
  end
end
