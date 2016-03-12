class ReviewBlacklistedJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # Note - this is technically inefficient, but at the scale we've got
    # (<10 blacklist entries) it doesn't much matter
    Blacklist.all.each do |blacklist_item|
      Lead.pending.where('title ilike ?', "%#{blacklist_item.substring}%")
        .update_all(reviewed: true)
    end
  end
end
