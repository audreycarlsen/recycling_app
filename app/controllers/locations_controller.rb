class LocationsController < ApplicationController
  def index
    results = LocationFinder.new(params["address"], params["subcategories"], params["type"])
    
    @drop_off_locations = results.drop_off_locations
    @pick_up_locations  = results.pick_up_locations
    @mail_in_locations  = results.mail_in_locations
    @locations_by_type  = results.locations_by_type

    @displayed_address = params["displayed_address"].split("near: ").last
    @current_location  = params["address"].split(",").map {|coord| coord.to_f}
    @materials         = params["subcategories"]
    @displayed_title   = display_title(params["subcategories"])

    if @drop_off_locations == nil
      redirect_to root_path, :flash => { :error => "There was a problem with your request. Please try again." }
    end
  end

  def email
    email_address    = params[:email_address]
    locations        = params[:locations]
    materials        = params[:materials]
    current_location = params[:current_location]

    Resque.enqueue(EmailJob, email_address, locations, materials, current_location)
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
        if subcategory == subcategories.last
          title = title + " and " + subcategory
        else
          title = title + subcategory + ", "
        end
      end
    end
    title
  end
end
