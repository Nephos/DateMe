class CreateMeetingDates < ActiveRecord::Migration
  def change
    create_table :meeting_dates do |t|
      t.timestamp :date
      t.references :meeting, index: true, foreign_key: true
      t.string :note

      t.timestamps null: false
    end
  end
end
