class EmailJob
  @queue = :email
  
  def self.perform(email_address, locations)
    ResultsMailer.send_results(email_address, locations).deliver
  end
end