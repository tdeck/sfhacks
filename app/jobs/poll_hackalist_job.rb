class PollHackalistJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    good_events = all_events.select { |e| good_event?(e) }
    good_events.each do |event|
      Lead.create!(
        source: 'hackalist',
        date: Date.parse(event[:startDate]),
        title: event[:title],
        location: event[:city],
        url: event[:url],
        key: event_key(event)
      )
    end

    Rails.logger.info("Added #{good_events.count} leads from hackalist.")
  end

  def good_event?(event)
    event[:city].include?('CA, United States') && !Lead.exists?(key: event_key(event))
  end

  def event_key(event)
    "hal-#{event[:title]}@#{event[:startDate]}, #{event[:year]}"
  end

  def all_events
    year = Date.today.year
    (Date.today.month..12).flat_map { |month| events_for_month(year, month) }
  end

  def events_for_month(year, month)
    url = 'https://www.hackalist.org/api/1.0/%04d/%02d.json' % [year, month]
    res = RestClient.get(url)
    json = JSON.parse(res.body).with_indifferent_access
    # This is something like {"February": [events...]}, so skip through the month
    json.values.first
  rescue RestClient::ResourceNotFound 
    # This month probably just doesn't have events yet
    []
  end
end
