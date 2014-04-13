class WelcomeController < ApplicationController
  def index
    @materials = Material.all.sort_by! {|material| material.name}
  end
end
