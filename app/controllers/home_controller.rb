class HomeController < ApplicationController
  def index
    @events = Event.current.order(:start_date)

    respond_to do |format|
      format.html
      format.atom
    end
  end
end
