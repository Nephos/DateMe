class CreateUserDates < ActiveRecord::Migration
  def change
    create_table :user_dates do |t|
      t.references :user, index: true, foreign_key: true
      t.references :meeting_date, index: true, foreign_key: true
      t.string :state

      t.timestamps null: false
    end

    add_index :user_dates, [ :user_id, :meeting_date_id ], unique: true
  end
end
