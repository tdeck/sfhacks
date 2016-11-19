class PollAndBlacklistJob < ActiveJob::Base
  queue_as :default
    
  def perform
    PollEventbriteJob.perform_now rescue nil
    PollMeetupJob.perform_now rescue nil
    PollDevpostJob.perform_now rescue nil
    PollHackworksJob.perform_now rescue nil
    PollMlhJob.perform_now rescue nil
    PollHackalistJob.perform_now rescue nil

    ReviewBlacklistedJob.perform_now
  end
end
