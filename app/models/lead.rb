# == Schema Information
#
# Table name: leads
#
#  id         :integer          not null, primary key
#  source     :string
#  date       :date
#  title      :string
#  location   :string
#  url        :string
#  reviewed   :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  key        :string
#
# Indexes
#
#  index_leads_on_date  (date)
#  index_leads_on_key   (key) UNIQUE
#

class Lead < ActiveRecord::Base
  scope :pending, -> { where('not reviewed and date >= ?', Date.today) }

  validates :key, uniqueness: true
  validates_presence_of :title, :date, :location, :url
end
