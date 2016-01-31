class AddKeyToLeads < ActiveRecord::Migration
  def change
    change_table :leads do |t|
      t.column :key, :string, null: true, unique: true
    end
  end
end
