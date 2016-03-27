atom_feed do |feed|
  feed.title("SF Bay Area Hackathons")
  feed.updated(@events.map(&:updated_at).max)
  @events.each do |event|
    feed.entry(
      event, 
      # We supply a URL in case the RSS reader is using it to dedup entries
      # instead of relying on the ID. This isn't ideal as old events won't
      # show up, but it's better than nothing.
      url: index_url() + "\#e#{event.id}",
      # We also put the start_date in the updated field so it shows up nicely
      updated: event.start_date
    ) do |entry|
      entry.title(event.title)
      content = event.blurb
      content += "\nAddress: #{event.venue} #{event.address}"
      content += "\nOnly open to #{event.restricted_to}" if event.restricted_to.present?
      entry.content(content)
    end
  end
end
