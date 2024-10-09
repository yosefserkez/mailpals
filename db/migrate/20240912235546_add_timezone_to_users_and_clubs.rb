class AddTimezoneToUsersAndClubs < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :timezone, :string
    add_column :clubs, :timezone, :string
  end
end