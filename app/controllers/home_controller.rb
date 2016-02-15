class HomeController < ApplicationController
  def index
    @events = Event.current.order(:start_date)
  end
end
