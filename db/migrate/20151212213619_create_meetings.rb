class CreateMeetingings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :name
      t.string :description
      t.timestamp :end_at
      t.json :dates

      t.timestamps null: false
    end
  end
end
