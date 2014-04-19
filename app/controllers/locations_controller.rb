class LocationsController < ApplicationController
  def index
    results = LocationFinder.new(params["address"], params["subcategories"], params["type"])
    
    @drop_off_locations = results.drop_off_locations
    @pick_up_locations = results.pick_up_locations
    @mail_in_locations = results.mail_in_locations
    @locations_by_type = results.locations_by_type

    @displayed_address = params["displayed_address"].split("near: ").last
    @current_location = params["address"].split(",").map {|coord| coord.to_f}
    @displayed_title = display_title(params["subcategories"])
  end

  def email
    email_address = params[:email_address]
    locations = params[:locations]
    ResultsMailer.send_results(email_address, locations).deliver
    render nothing: true
  end

  private

  def display_title(subcategories)
    title = ""
    subcategories.each do |subcategory|
      if subcategories.count == 1
        title = subcategory
      elsif subcategories.count == 2
        unless subcategory == subcategories.last
          title = subcategory
        else
          title = title + " and " + subcategory
        end
      else
        unless subcategory == subcategories.last
           title = subcategory + ","
        else
          title = title + " and " + subcategory
        end
      end
    end
    title
  end
end
