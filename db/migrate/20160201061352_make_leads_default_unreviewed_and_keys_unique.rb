class MakeLeadsDefaultUnreviewedAndKeysUnique < ActiveRecord::Migration
  def change
    change_table :leads do |t|
      t.change :reviewed, :boolean, null: false, default: false
      t.index :key, unique: true
    end
  end
end
