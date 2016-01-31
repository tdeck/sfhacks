class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.date :start_date, null: false, index: true
      t.date :end_date # null == one day event
      t.string :address, null: false
      t.string :title, null: false
      t.string :link, null: false
      t.text :blurb, null: false
      t.integer :hours

      t.timestamps null: false
    end
  end
end
