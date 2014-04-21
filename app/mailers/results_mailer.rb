class ResultsMailer < ActionMailer::Base
  default from: "admin@wdidw.com"

  def send_results(email_address, locations, materials, current_location)
    @drop_off_locations = locations["drop_off"]
    @pick_up_locations  = locations["pick_up"]
    @mail_in_locations  = locations["mail_in"]
    @current_location   = current_location
    @materials          = materials

    mail(to: email_address, subject: 'What Do I Do With...?')
  end
end
