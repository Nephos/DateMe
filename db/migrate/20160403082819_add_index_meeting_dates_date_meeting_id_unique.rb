class AddIndexMeetingDatesDateMeetingIdUnique < ActiveRecord::Migration
  def change
    add_index :meeting_dates, [:meeting_id, :date], unique: true
  end
end
