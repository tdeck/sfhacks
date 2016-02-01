require_relative '../config/environment'
require 'clockwork'
include Clockwork

every(1.hour, 'grab_leads') do
  PollEventbriteJob.perform_later
end
