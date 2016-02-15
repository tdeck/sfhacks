class Admin::ListingsController < ApplicationController
  helper_method :listings
  before_action :require_admin

  def index
  end

  def create
    args = params.permit(
      :title,
      :venue,
      :address,
      :link,
      :blurb,
      :start_date,
      :end_date,
      :hours,
      :restricted_to
    )

    args[:start_date] = Date.parse(args[:start_date])
    if args[:end_date].present?
      args[:end_date] = Date.parse(args[:end_date])
    else
      args.delete(:end_date)
    end
    if args[:hours].present?
      args[:hours] = args[:hours].to_i
    else
      args.delete(:hours)
    end

    Event.create!(args)

    redirect_to action: :index
  end

  def patch
    lead_ids = params.require(:reviewed_leads)
    lead_ids.each do |id|
      lead = Lead.find_by_id!(id.to_i)
      Rails.logger.info "Reviewed lead:"
      Rails.logger.info lead
      lead.reviewed = true
      lead.save!
    end
  
    redirect_to action: :index
  end

  def listings
    @listings ||= (Lead.pending.map do |lead|
      {
        lead_id: lead.id,
        source: lead.source,
        date: lead.date,
        title: lead.title,
        location: lead.location,
        url: lead.url
      }
    end + Event.current.map do |event|
      {
        date: event.start_date,
        title: event.title,
        location: event.address,
        url: event.link
      }
    end).sort_by { |x| [ x[:date], x[:title].downcase ] }
  end

private
  def require_admin
    Rails.logger.info "SESSION: #{session[:admin]}"
    redirect_to controller: :login, action: :show if !session[:admin]
  end
end
