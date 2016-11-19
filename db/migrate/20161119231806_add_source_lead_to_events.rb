class AddSourceLeadToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.references :source_lead, references: :lead, null: true
    end
  end
end
