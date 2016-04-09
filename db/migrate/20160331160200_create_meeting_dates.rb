class CreateMeetingDates < ActiveRecord::Migration
  def change
    create_table :meeting_dates do |t|
      t.timestamp :date
      t.uuid :meeting_uuid, index: true, foreign_key: true
      t.text :note

      t.timestamps null: false
    end
    add_index :meeting_dates, [ :meeting_uuid, :date ], unique: true
  end
end
