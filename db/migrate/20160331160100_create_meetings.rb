class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string      :name, null: false, limit: 64 # minimum 4
      t.text        :description
      t.timestamp   :end_at
      t.references  :user
      t.uuid        :uuid, null: false, index: true, unique: true

      t.timestamps null: false
    end
  end
end
