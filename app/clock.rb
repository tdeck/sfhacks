require_relative '../config/environment'
require 'clockwork'
include Clockwork

every(1.day, 'grab_leads', at: '15:00', tz: 'America/Los_Angeles') do
  PollAndBlacklistJob.perform_now
  MailAlerterJob.perform_now
end
