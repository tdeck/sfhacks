require_relative '../config/environment'
require 'clockwork'
include Clockwork

every(1.day, 'grab_leads', at: '15:00', tz: 'America/Los_Angeles') do
  PollEventbriteJob.perform_later
  PollMeetupJob.perform_later
  PollDevpostJob.perform_later
  PollHackworksJob.perform_later
  PollMlhJob.perform_later
  PollHackalistJob.perform_later

  ReviewBlacklistedJob.set(wait: 5.minutes).perform_later
  MailAlerterJob.set(wait: 6.minutes).perform_later
end
