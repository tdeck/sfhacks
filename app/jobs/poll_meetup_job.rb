class PollMeetupJob < ActiveJob::Base
  queue_as :default

  # TODO need to add deduplication
  def perform(*args)
    good_events = all_events.reject { |e| Lead.exists?(key: event_key(e)) }

    good_events.each do |event|
      address = '(unknown)' 
      if event.has_key?(:venue)
        address = (
          event[:venue]
            .values_at(:address_1, :address_2, :city, :state)
            .compact.join(', ')
        )
      end

      Lead.create!(
        source: 'meetup',
        date: Time.at(event[:time] / 1000).to_date,
        title: event[:name],
        location: address,
        url: event[:event_url],
        key: event_key(event),
        reviewed: false
      )
    end

    Rails.logger.info("Added #{good_events.count} leads from meetup.")
  end

  def event_key(event)
    "mu-#{event[:id]}"
  end

  def all_events
    res = RestClient.get(
      'https://api.meetup.com/2/open_events',
      params: {
        key: Rails.application.secrets.meetup_key,
        status: 'upcoming',
        zip: 94103,
        radius: 50,
        text: 'hackathon',
        page: 200,
      }
    )

    JSON.parse(res.body).with_indifferent_access[:results]
  end
end
