class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :name, null: false
      t.string :description
      t.timestamp :end_at
      t.references :user
      t.string :uuid, null: false, index: true, unique: true

      t.timestamps null: false
    end
  end
end
