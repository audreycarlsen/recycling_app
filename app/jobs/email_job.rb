class EmailJob
  @queue = :email
  
  def self.perform(email_address, locations, materials, current_location)
    ResultsMailer.send_results(email_address, locations, materials, current_location).deliver
  end
end