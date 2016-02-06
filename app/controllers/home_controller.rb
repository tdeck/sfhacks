class HomeController < ApplicationController
  def show
    @events = Event.current.order(:start_date)
  end
end
