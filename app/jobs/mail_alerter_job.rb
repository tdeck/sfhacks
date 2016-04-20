class MailAlerterJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    count30 = Lead.pending.where('date < ?', Date.today + 30.days).count
    if count30 > 0
      count7 = Lead.pending.where('date < ?', Date.today + 7.days).count
      text = "There are #{count30} un-reviewed leads on sfhacks.com for events in the next 30 days."
      text += "\nThere are #{count7} within the next 7 days!" if count7 > 0
      RestClient.post(
        'https://varmail.me/d8NWC6f8S9SR',
        subject: 'New event leads to review',
        text: text
      )
    end
  end
end
