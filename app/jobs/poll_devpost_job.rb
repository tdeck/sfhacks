require 'open-uri'

class PollDevpostJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    good_events = all_events.select { |e| good_event?(e) }
    good_events.each do |event|
      Lead.create!(event)
    end

    Rails.logger.info("Added #{good_events.count} leads from devpost.")
  end

  def good_event?(event)
    # Filter out Canadian events
    (
      event[:location].include?('CA, US') ||
      event[:location].empty?
        # Some events don't have a listed location, oddly, and we don't
        # want to leave them out
    ) && !Lead.exists?(key: event[:key])
  end

  def first_date(range)
    # Parses date ranges in 3 formats:
    # 1. Dec 12, 2015
    # 2. Feb 6 – 7, 2016
    # 3. Jan 16 – Feb 1, 2016
    # Doesn't handle events that span years (oh well)
    case range.strip
      when /^(\w+) (\d+), (\d+)$/
        Date.parse("#{$1} #{$2}, #{$3}")
      when /^(\w+) (\d+) – \d+, (\d+)$/
        Date.parse("#{$1} #{$2}, #{$3}")
      when /^(\w+) (\d+) – \w+ \d+, (\d+)$/
        Date.parse("#{$1} #{$2}, #{$3}")
    end
  end

  def all_events
    events = []
    # Theoretically we should handle pagination but there aren't enough future
    # events to go beyond one page
    dom = Nokogiri::HTML(
      open("http://devpost.com/hackathons?search=CA&challenge_type=in-person&sort_by=Submission+Deadline")
    )

    dom.css('article.challenge-listing').map do |article|
      url = article.css('a[data-role=featured_challenge]').first[:href]
      {
        source: 'devpost',
        title: article.css('h2.title').text.strip,
        location: article.css('p.challenge-location').text.strip,
        url: url,
        date: first_date(article.css('span.date-range').text.strip),
        key: URI(url).host,
      }
    end
  end
end
