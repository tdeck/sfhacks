class PollHackworksJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Rails.logger.info "AEC #{all_events.count}"
    good_events = all_events.reject { |e| bad_event?(e) }

    good_events.each do |event|
      Lead.create!(
        source: 'hackworks',
        date: first_date(event[:date]),
        title: event[:name],
        location: "#{event[:city]}, #{event[:province]}, #{event[:country]}",
        url: event[:website],
        key: event_key(event),
        reviewed: false
      )
    end

    Rails.logger.info("Added #{good_events.count} leads from hackathonsnear.me (hackworks).")
  end
  
  def bad_event?(event)
    event[:virtual] == 1 ||
      event[:country] != 'US' ||
      event[:province] != 'CA' ||
      first_date(event[:date]) < Date.today ||
      Lead.exists?(key: event_key(event))
  end

  def event_key(event)
    "hw-#{event[:name]}@#{event[:date]}"
  end

  def first_date(date_str)
    # Handles three date types and pulls out the first date
    # 1. "Apr 2, 2016"
    # 2. "Feb 5-7, 2016"
    # 3. "Sep 15, 2015 - Feb 24, 2016"
    d = date_str.gsub(/-\d+/, '')
    d = d.gsub(/ - .*/, '')
    Date.parse(d)
  end

  def all_events
    # This is scraping a frontend AJAX API, so there's
    # no guarantee that it will remain stable
    res = RestClient.get(
      'http://hackathonsnear.me/api/hackathons/get',
      Referer: 'http://hackathonsnear.me/' # Required
    )

    JSON.parse(res.body).map(&:with_indifferent_access)
  end
end
