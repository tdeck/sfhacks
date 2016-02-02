class PollEventbriteJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    good_events = all_events.reject { |e| bad_event?(e) }

    good_events.each do |event|
      Lead.create!(
        source: 'eventbrite',
        date: Date.iso8601(event[:start][:utc]),
        title: event[:name][:text],
        location:
          event[:venue][:address]
            .values_at(:address_1, :address_2, :city, :region)
            .compact.join(', '),
        url: event[:url],
        key: event_key(event),
        reviewed: false
      )
    end

    Rails.logger.info("Added #{good_events.count} leads from eventbrite.")
  end

  def event_key(event)
    "eb-#{event[:id]}"
  end

  def bad_event?(event)
    # TODO we should be able to pull canceled events later
    event[:online_event] ||
      event[:status].in?(%w(canceled ended)) ||
      Lead.exists?(key: event_key(event))
  end

  def all_events
    page = 1
    page_count = 100 # Will be reset
    events = []
    while page <= page_count
      res = RestClient.get(
        'https://www.eventbriteapi.com/v3/events/search/',
        Authorization: "Bearer #{Rails.application.secrets.eventbrite_token}",
        params: {
          'q' => 'hackathon',
          'location.address' => '1 Dr Carlton B Goodlett Pl, San Francisco, CA 94102',
          'location.within' => '50mi',
          'start_date.range_start' => Date.today.midnight.iso8601,
          'page': page,
          'expand': 'venue',
        }
      )
      json = JSON.parse(res.body).with_indifferent_access
      events += json[:events]

      page_count = json[:pagination][:page_count]
      page += 1
      Rails.logger.info page_count
    end
    return events
  end
end
