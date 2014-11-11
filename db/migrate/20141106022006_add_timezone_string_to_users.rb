class AddTimezoneStringToUsers < ActiveRecord::Migration
  def change
    add_column :users, :timezone_string, :string
  end
end
