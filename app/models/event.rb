# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  start_date     :date             not null
#  end_date       :date
#  address        :string           not null
#  title          :string           not null
#  link           :string           not null
#  blurb          :text             not null
#  hours          :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  venue          :string           default(""), not null
#  restricted_to  :string
#  source_lead_id :integer
#
# Indexes
#
#  index_events_on_start_date  (start_date)
#

class Event < ActiveRecord::Base
  scope :current, -> { where('start_date >= ?', Date.today) }
  validates_presence_of :title, :start_date, :address, :link, :blurb
  belongs_to :source_lead, class_name: 'Lead'

  def update_url
    "/admin/listings/#{id}"
  end
  def edit_url
    "/admin/listings/#{id}/edit"
  end
end
