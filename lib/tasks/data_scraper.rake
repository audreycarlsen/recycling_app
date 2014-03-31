task :data_scraper => :environment do
  DataScraper.get_all
end