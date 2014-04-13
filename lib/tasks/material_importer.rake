task :material_importer => :environment do
  MaterialImporter.get_all
end