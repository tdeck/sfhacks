class AddVenueToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.column :venue, :string, null: false, default: ''
    end
  end
end
