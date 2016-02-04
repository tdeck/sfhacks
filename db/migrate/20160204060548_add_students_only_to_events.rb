class AddStudentsOnlyToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.column :students_only, :boolean, null: false, default: false
    end
  end
end
