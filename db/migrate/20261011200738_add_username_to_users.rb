class AddUsernameToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :username, :string

    up_only do
      execute "UPDATE users SET username = 'admin'"
    end
  end
end
