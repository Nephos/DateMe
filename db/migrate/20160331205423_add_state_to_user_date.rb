class AddStateToUserDate < ActiveRecord::Migration
  def change
    add_column :user_dates, :state, :string
  end
end
