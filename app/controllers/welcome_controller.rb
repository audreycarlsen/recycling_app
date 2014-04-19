require 'redcarpet'

class WelcomeController < ApplicationController
  def index
    @materials = Material.all.sort_by! {|material| material.name}
  end

  def api
    @markdown = Redcarpet::Markdown.new(renderer, extensions = {})
  end
end
