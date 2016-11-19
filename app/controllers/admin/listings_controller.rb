class Admin::ListingsController < ApplicationController
  helper_method :listings
  before_action :require_admin

  def index
    @event = Event.new
    @form_params = {url: '/admin/listings'}
  end

  def new
    @event = Event.new
    @form_params = {url: '/admin/listings'}
    if params[:lead_id]
      @lead = Lead.find_by_id(params[:lead_id])
      @event.update_attributes(
        title: @lead.title,
        start_date: @lead.date,
        link: @lead.url,
        address: @lead.location,
        source_lead_id: @lead.id
      )

      @event.update_attributes(@lead.other_fields)
    end
  end

  def create
    event = Event.create!(event_params)

    # If this was derived from a particular lead, mark that lead true when we
    # create the event
    lead = event.source_lead
    if event.source_lead
       lead.reviewed = true
       lead.save!
    end

    redirect_to admin_listings_url, notice: 'Post successfully created.'
  end

  def patch
    lead_ids = params.require(:reviewed_leads)
    lead_ids.each do |id|
      lead = Lead.find_by_id!(id.to_i)
      lead.reviewed = true
      lead.save!
    end

    notice = lead_ids.count > 0 ? "Hid #{lead_ids.count} lead(s)." : nil
    Rails.logger.info "NOTICE: #{notice}"
  
    redirect_to admin_listings_url, notice: notice
  end

  def edit
    @event = Event.find(params[:id])
    @form_params = {
      url: @event.update_url,
      method: :put
    }
  end

  def update
    event = Event.find(params[:id])
    event.update_attributes!(event_params)
    redirect_to admin_listings_url, notice: 'Post successfully updated.'
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
        event_id: event.id,
        edit_url: event.edit_url,
        date: event.start_date,
        title: event.title,
        location: event.address,
        url: event.link
      }
    end).sort_by { |x| [ x[:date], x[:title].downcase ] }
  end

private
  def event_params
    args = params.require(:event).permit(
      :title,
      :venue,
      :address,
      :link,
      :blurb,
      :start_date,
      :end_date,
      :hours,
      :restricted_to,
      :source_lead_id
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

    args
  end
end
