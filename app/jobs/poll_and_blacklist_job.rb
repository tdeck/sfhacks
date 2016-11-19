class PollAndBlacklistJob < ActiveJob::Base
  queue_as :default
    
  def perform
    PollEventbriteJob.perform_now
    PollMeetupJob.perform_now
    PollDevpostJob.perform_now
    PollHackworksJob.perform_now
    PollMlhJob.perform_now
    PollHackalistJob.perform_now

    ReviewBlacklistedJob.perform_now
  end
end
