class Admin::SyncController < ApplicationController
  before_action :require_admin

  # POST /admin/sync
  def sync
    PollAndBlacklistJob.perform_later
    redirect_to admin_listings_url, notice: 'Sync started.'
  end
end
