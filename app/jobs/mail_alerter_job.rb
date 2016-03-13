class MailAlerterJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    count = Lead.pending.where('date < ?', Date.today + 30.days).count
    if count > 0
      RestClient.post(
        'https://varmail.me/d8NWC6f8S9SR',
        subject: 'New event leads to review',
        text: "There are #{count} un-reviewed leads on sfhacks.com for events in the next 30 days."
      )
    end
  end
end
