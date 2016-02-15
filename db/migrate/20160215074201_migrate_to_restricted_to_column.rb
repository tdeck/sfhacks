class MigrateToRestrictedToColumn < ActiveRecord::Migration
  def self.up
    add_column :events, :restricted_to, :string, null: false, default: ''

    Event.reset_column_information
    Event.where(students_only: true).each do |e|
      e.restricted_to = 'students'
      e.save!
    end

    remove_column :events, :students_only
  end
end
