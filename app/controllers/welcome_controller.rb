class WelcomeController < ApplicationController
  def index
    @materials = Material.all
  end
end
