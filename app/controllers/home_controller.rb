class HomeController < ApplicationController
  def show
    @events = Event.current
  end
end
