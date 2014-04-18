class LocationsController < ApplicationController
  def index
    LocationFinder.new(params["address"], params["subcategories"], params["type"])
    @displayed_address = params["displayed_address"].split("near: ").last
    @displayed_title = display_title(params["subcategories"])
  end

  def email
    email_address = params[:email]
    locations = params[:locations]
    ResultsMailer.send_results(email_address, locations).deliver
    render nothing: true
  end

  private

  def calculate_distances(current_location, destination_coords)
    url = ("https://maps.googleapis.com/maps/api/distancematrix/json?origins=" + current_location + "&destinations=" + destination_coords + "&sensor=false&units=imperial&key=" + ENV['GOOGLE_SERVER_API_KEY']).strip
    HTTParty.get(URI.encode(url))
  end

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
