class AddOtherFieldsToLeads < ActiveRecord::Migration
  def change
    change_table :leads do |t|
      t.column :other_fields, :json, null: false, default: '{}'
    end
  end
end
