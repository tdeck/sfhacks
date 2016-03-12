# == Schema Information
#
# Table name: blacklists
#
#  id         :integer          not null, primary key
#  substring  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Blacklist < ActiveRecord::Base
end
