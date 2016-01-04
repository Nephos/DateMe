class AddIndexUserDatesUserIdMeetingDateIdUnique < ActiveRecord::Migration
  def change
    add_index :user_dates, [:user_id, :meeting_date_id], unique: true
  end
end
