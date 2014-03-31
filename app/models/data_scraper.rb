class DataScraper
  def self.get_all
    response = HTTParty.get('http://data.kingcounty.gov/resource/zqwi-c5q3.json')
  end
end
