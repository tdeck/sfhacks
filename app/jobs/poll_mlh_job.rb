require 'open-uri'

class PollMlhJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    good_events = all_events.select { |e| good_event?(e) }
    good_events.each do |event|
      Lead.create!(event)
    end

    Rails.logger.info("Added #{good_events.count} leads from MLH.")
  end

  def good_event?(event)
    event[:location].include?(', CA') && !Lead.exists?(key: event[:key])
  end

  # The code below is based on https://github.com/MLH/cal.mlh.io

  def get_season
    "na-#{Time.now.year.to_s}"
  end

  def mlh_url
    "https://mlh.io/seasons/#{get_season}/events"
  end

  def parse_time(time_string)
    Time.parse(time_string)
  end

  def all_events
    doc = Nokogiri::HTML(open(mlh_url))

    doc.css('.event').map do |e|
      # Strangely, it appears as though events' unique IDs are in a CSS class
      # on each event box
      event_key = "mlh-#{e.attribute('class').to_s.match(/event-\d+/)}"

      event_name = e.css('h3').first.content.to_s
      event_url = e.css('.event-wrapper > a[target="_blank"]').first.attribute("href").to_s
      event_date = e.css('p')[0].content.to_s.gsub(/(?<=[0-9])(?:st|nd|rd|th)/, "")
      event_location = e.css('p')[1].content.to_s

      event_date_split = event_date.split(' - ')

      if event_date_split.count == 2
        event_start = parse_time(event_date_split[0])
      else
        event_start = parse_time(event_date)
        event_end = Date.parse(event_date) + (60*60*48) if Time.parse(event_date).wday == 5 # if starts on a friday, it usually ends on sunday
        event_end = Date.parse(event_date) + (60*60*24) if Time.parse(event_date).wday == 6 # if starts on saturday, it usually ends on a sunday
        event_end = parse_time(event_end.to_s)
      end

      {
        source: 'mlh',
        title: event_name,
        location: event_location,
        url: event_url,
        date: event_start.to_date,
        key: event_key
      }
    end
  end
end
