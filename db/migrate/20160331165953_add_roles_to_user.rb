class AddRolesToUser < ActiveRecord::Migration
  def change
    add_column :users, :roles, :json, default: %w(default), null: false
  end
end
