class ResultsMailer < ActionMailer::Base
  default from: "admin@wdidw.com"

  def send_results(email_address, locations)
    @drop_off_locations = locations

    mail(to: email_address, subject: 'What Do I Do With...?')
  end
end
