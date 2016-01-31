class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :source
      t.date :date
      t.string :title
      t.string :location
      t.string :url
      t.boolean :reviewed

      t.timestamps null: false
    end
    add_index :leads, :date
  end
end
